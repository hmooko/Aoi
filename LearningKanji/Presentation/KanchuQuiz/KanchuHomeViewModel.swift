//
//  KanchuHomeViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/25.
//

import Foundation

extension KanchuHomeView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        private let fetchAllKanchuProjectsUseCase: FetchAllKanchuProjectsUseCase
        private let insertKanchuProjectUseCase: InsertKanchuProjectUseCase
        private let deleteKanchuProjectUseCase: DeleteKanchuProjectUseCase
        private let updateKanchuProjectUseCase: UpdateKanchuProjectUseCase
        
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
            
            fetchAllKanchuProjects()
        }
        
        private func fetchAllKanchuProjects() {
            Task {
                do {
                    let projects = try await fetchAllKanchuProjectsUseCase.execute(sortOption: .createdAt(ascending: true))
                    self.projects = projects
                    self.viewState = .loaded
                } catch {
                    print("Error fetching all kanchu projects: \(error)")
                }
            }
        }
        
        func togglePin(for project: KanchuProject) {
            Task {
                do {
                    let updatedProject = KanchuProject(
                        id: project.id,
                        name: project.name,
                        createdAt: project.createdAt,
                        questionCount: project.questionCount,
                        questions: project.questions,
                        isPinned: !project.isPinned
                    )
                    try await updateKanchuProjectUseCase.execute(project: updatedProject)
                    fetchAllKanchuProjects() // Refresh the list after toggling
                } catch {
                    print("Error toggling pin for project: \(error)")
                }
            }
        }
        
    }
}
