//
//  FetchAllKanchuProjectsUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 2025/07/23
//

import Foundation

protocol FetchAllKanchuProjectsUseCase {
    func execute(sortOption: DefaultFetchAllKanchuProjectsUseCase.SortOption) async throws -> [KanchuProject]
}

final class DefaultFetchAllKanchuProjectsUseCase: FetchAllKanchuProjectsUseCase {
    
    public enum SortOption {
        case name(ascending: Bool)
        case createdAt(ascending: Bool)
        case questionCount(ascending: Bool)
    }
    
    private let kanchuRepository: KanchuProjectRepository
    
    init(kanchuRepository: KanchuProjectRepository) {
        self.kanchuRepository = kanchuRepository
    }
    
    func execute(sortOption: SortOption) async throws -> [KanchuProject] {
        let projects = try await kanchuRepository.fetchAllProjects()
        
        let sortedProjects = projects.sorted { lhs, rhs in
            switch sortOption {
            case .name(let ascending):
                let comparison = lhs.name.localizedStandardCompare(rhs.name)
                return ascending ? (comparison == .orderedAscending) : (comparison == .orderedDescending)
            case .createdAt(let ascending):
                return ascending ? (lhs.createdAt < rhs.createdAt) : (lhs.createdAt > rhs.createdAt)
            case .questionCount(let ascending):
                return ascending ? (lhs.questionCount < rhs.questionCount) : (lhs.questionCount > rhs.questionCount)
            }
        }
        
        return sortedProjects
    }
}

// MARK: - Mock for Preview/Testing
final class MockFetchAllKanchuProjectsUseCase: FetchAllKanchuProjectsUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository
    
    init(kanchuProjectRepository: KanchuProjectRepository) {
        self.kanchuProjectRepository = kanchuProjectRepository
    }
    
    func execute(sortOption: DefaultFetchAllKanchuProjectsUseCase.SortOption) async throws -> [KanchuProject] {
        let projects = try await kanchuProjectRepository.fetchAllProjects()
        
        let sortedProjects = projects.sorted { lhs, rhs in
            switch sortOption {
            case .name(let ascending):
                let comparison = lhs.name.localizedStandardCompare(rhs.name)
                return ascending ? (comparison == .orderedAscending) : (comparison == .orderedDescending)
            case .createdAt(let ascending):
                return ascending ? (lhs.createdAt < rhs.createdAt) : (lhs.createdAt > rhs.createdAt)
            case .questionCount(let ascending):
                return ascending ? (lhs.questionCount < rhs.questionCount) : (lhs.questionCount > rhs.questionCount)
            }
        }
        return sortedProjects
    }
}
