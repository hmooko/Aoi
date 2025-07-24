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
        
    }
}
