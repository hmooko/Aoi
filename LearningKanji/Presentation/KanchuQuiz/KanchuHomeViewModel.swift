//
//  KanchuHomeViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/25.
//

import Foundation
import os

extension KanchuHomeView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "KanchuHomeViewModel")
        
        private let fetchAllKanchuProjectsUseCase: FetchAllKanchuProjectsUseCase
        private let deleteKanchuProjectUseCase: DeleteKanchuProjectUseCase
        private let renameKanchuProjectUseCase: RenameKanchuProjectUseCase
        private let toggleKanchuProjectPinStateUseCase: ToggleKanchuProjectPinStateUseCase
        private(set) var router: Router
        
        @Published private(set) var projects: [KanchuProject] = []
        @Published private(set) var viewState: ViewState = .loading
        @Published var projectToRename: KanchuProject?
        @Published var newProjectName: String = ""
        
        enum ViewState {
            case loading
            case loaded
        }
        
        init(container: DIContainer) {
            fetchAllKanchuProjectsUseCase = container.fetchAllKanchuProjectsUseCase()
            deleteKanchuProjectUseCase = container.deleteKanchuProjectUseCase()
            renameKanchuProjectUseCase = container.renameKanchuProjectUseCase()
            toggleKanchuProjectPinStateUseCase = container.toggleKanchuProjectPinStateUseCase()
            self.router = container.router
            logger.info("KanchuHomeViewModel이 초기화되었습니다.")
        }
        
        func fetchAllKanchuProjects() {
            logger.debug("모든 Kanchu 프로젝트를 가져옵니다.")
            Task {
                do {
                    let projects = try await fetchAllKanchuProjectsUseCase.execute(sortOption: .createdAt(ascending: true))
                    self.projects = projects
                    self.viewState = .loaded
                    logger.info("\(projects.count)개의 프로젝트를 성공적으로 가져왔습니다.")
                } catch {
                    logger.error("모든 Kanchu 프로젝트를 가져오는 중 오류 발생: \(error.localizedDescription)")
                }
            }
        }
        
        func togglePin(for project: KanchuProject) {
            logger.debug("프로젝트 \(project.id, privacy: .public)의 핀 상태를 변경합니다.")
            Task {
                do {
                    try await toggleKanchuProjectPinStateUseCase.execute(project: project)
                    self.fetchAllKanchuProjects()
                } catch {
                    logger.error("프로젝트 \(project.id, privacy: .public)의 핀 상태 변경 중 오류 발생: \(error.localizedDescription)")
                }
            }
        }
        
        func createQuiz() {
            logger.debug("KanchuQuizScene으로 이동합니다.")
            router.push(.kanchuQuizScene)
        }
        
        func deleteProject(_ project: KanchuProject) {
            logger.debug("프로젝트 \(project.id, privacy: .public) 삭제를 시도합니다.")
            Task {
                do {
                    try await deleteKanchuProjectUseCase.execute(ids: [project.id])
                    logger.info("프로젝트 \(project.id, privacy: .public)를 성공적으로 삭제했습니다. UI에서 제거합니다.")
                    projects.removeAll { $0.id == project.id }
                } catch {
                    logger.error("프로젝트 \(project.id, privacy: .public) 삭제 중 오류 발생: \(error.localizedDescription)")
                }
            }
        }
        
        func selectProjectToRename(_ project: KanchuProject) {
            logger.debug("프로젝트 \(project.id, privacy: .public) 이름 변경을 시작합니다.")
            self.projectToRename = project
            self.newProjectName = project.name
        }

        func cancelProjectRename() {
            self.projectToRename = nil
            self.newProjectName = ""
        }

        func commitProjectRename() {
            guard let project = projectToRename else {
                logger.warning("이름을 변경할 프로젝트가 선택되지 않았습니다.")
                return
            }
            
            // `newProjectName`을 즉시 지역 변수에 복사하여 레이스 컨디션을 방지합니다.
            let nameToSet = newProjectName
            
            guard !nameToSet.isEmpty, nameToSet != project.name else {
                logger.info("프로젝트 이름이 변경되지 않았거나 비어있어 작업을 취소합니다.")
                cancelProjectRename()
                return
            }
            
            logger.debug("프로젝트 \(project.id, privacy: .public)의 이름을 '\(nameToSet, privacy: .public)'(으)로 변경합니다.")
            Task {
                do {
                    // 복사해둔 지역 변수를 사용하여 이름 변경을 처리합니다.
                    let updatedProject = try await renameKanchuProjectUseCase.execute(project: project, newName: nameToSet)
                    
                    if let index = self.projects.firstIndex(where: { $0.id == project.id }) {
                        self.projects[index] = updatedProject
                    }
                    self.cancelProjectRename()
                    logger.info("프로젝트 \(project.id, privacy: .public)의 이름을 성공적으로 변경했습니다.")
                    
                } catch {
                    logger.error("프로젝트 \(project.id, privacy: .public)의 이름 변경 중 오류 발생: \(error.localizedDescription)")
                    self.cancelProjectRename()
                }
            }
        }
        
        func startQuiz(project: KanchuProject) {
            router.push(.kanchuQuizWithProjectScene(project))
        }
    }
}
