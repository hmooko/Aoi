//
//  FetchAllKanchuProjectsUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 2025/07/23
//

import Foundation

protocol FetchAllKanchuProjectsUseCase {
    func execute() async throws -> [KanchuProject]
}

final class DefaultFetchAllKanchuProjectsUseCase: FetchAllKanchuProjectsUseCase {
    private let kanchuRepository: KanchuProjectRepository
    
    init(kanchuRepository: KanchuProjectRepository) {
        self.kanchuRepository = kanchuRepository
    }
    
    func execute() async throws -> [KanchuProject] {
        try await kanchuRepository.fetchAllProjects()
    }
}

// MARK: - Mock for Preview/Testing
final class MockFetchAllKanchuProjectsUseCase: FetchAllKanchuProjectsUseCase {
    private let mockProjects: [KanchuProject]
    
    init(mockProjects: [KanchuProject] = [createExampleProject()]) {
        self.mockProjects = mockProjects
    }
    
    func execute() async throws -> [KanchuProject] {
        mockProjects
    }
}
