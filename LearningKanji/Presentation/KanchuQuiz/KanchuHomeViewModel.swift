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
        private let insertKanchuProjectUseCase: InsertKanchuProjectUseCase
        private let deleteKanchuProjectUseCase: DeleteKanchuProjectUseCase
        private let updateKanchuProjectUseCase: UpdateKanchuProjectUseCase
        private(set) var router: Router
        
        @Published private(set) var projects: [KanchuProject] = []
        @Published private(set) var viewState: ViewState = .loading
        
        enum ViewState {
            case loading
            case loaded
        }
        
        init(container: DIContainer) {
            fetchAllKanchuProjectsUseCase = container.fetchAllKanchuProjectsUseCase()
            insertKanchuProjectUseCase = container.insertKanchuProjectUseCase()
            deleteKanchuProjectUseCase = container.deleteKanchuProjectUseCase()
            updateKanchuProjectUseCase = container.updateKanchuProjectUseCase()
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
                    let updatedProject = KanchuProject(
                        id: project.id,
                        name: project.name,
                        createdAt: project.createdAt,
                        questions: project.questions,
                        isPinned: !project.isPinned
                    )
                    try await updateKanchuProjectUseCase.execute(project: updatedProject)
                    logger.info("프로젝트 \(project.id, privacy: .public)의 핀 상태를 성공적으로 변경했습니다. 목록을 새로고침합니다.")
                    fetchAllKanchuProjects() // Refresh the list after toggling
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
        
        func startQuiz(project: KanchuProject) {
            router.push(.kanchuQuizWithProjectScene(project))
        }
    }
}
