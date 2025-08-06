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
        
        // Pinned 프로젝트와 Unpinned 프로젝트를 분리합니다.
        let pinnedProjects = projects.filter { $0.isPinned }
        let unpinnedProjects = projects.filter { !$0.isPinned }
        
        // 각 그룹을 sortOption에 따라 정렬합니다.
        let sortedPinnedProjects = pinnedProjects.sorted { lhs, rhs in
            switch sortOption {
            case .name(let ascending):
                let comparison = lhs.name.localizedStandardCompare(rhs.name)
                return ascending ? (comparison == .orderedAscending) : (comparison == .orderedDescending)
            case .createdAt(let ascending):
                return ascending ? (lhs.createdAt < rhs.createdAt) : (lhs.createdAt > rhs.createdAt)
            case .questionCount(let ascending):
                return ascending ? (lhs.questions.count < rhs.questions.count) : (lhs.questions.count > rhs.questions.count)
            }
        }
        
        let sortedUnpinnedProjects = unpinnedProjects.sorted { lhs, rhs in
            switch sortOption {
            case .name(let ascending):
                let comparison = lhs.name.localizedStandardCompare(rhs.name)
                return ascending ? (comparison == .orderedAscending) : (comparison == .orderedDescending)
            case .createdAt(let ascending):
                return ascending ? (lhs.createdAt < rhs.createdAt) : (lhs.createdAt > rhs.createdAt)
            case .questionCount(let ascending):
                return ascending ? (lhs.questions.count < rhs.questions.count) : (lhs.questions.count > rhs.questions.count)
            }
        }
        
        // Pinned 프로젝트를 맨 앞에, 그 뒤에 Unpinned 프로젝트를 합쳐 반환합니다.
        return sortedPinnedProjects + sortedUnpinnedProjects
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
        
        // Mock에서도 동일한 로직을 적용합니다.
        let pinnedProjects = projects.filter { $0.isPinned }
        let unpinnedProjects = projects.filter { !$0.isPinned }
        
        let sortedPinnedProjects = pinnedProjects.sorted { lhs, rhs in
            switch sortOption {
            case .name(let ascending):
                let comparison = lhs.name.localizedStandardCompare(rhs.name)
                return ascending ? (comparison == .orderedAscending) : (comparison == .orderedDescending)
            case .createdAt(let ascending):
                return ascending ? (lhs.createdAt < rhs.createdAt) : (lhs.createdAt > rhs.createdAt)
            case .questionCount(let ascending):
                return ascending ? (lhs.questions.count < rhs.questions.count) : (lhs.questions.count > rhs.questions.count)
            }
        }
        
        let sortedUnpinnedProjects = unpinnedProjects.sorted { lhs, rhs in
            switch sortOption {
            case .name(let ascending):
                let comparison = lhs.name.localizedStandardCompare(rhs.name)
                return ascending ? (comparison == .orderedAscending) : (comparison == .orderedDescending)
            case .createdAt(let ascending):
                return ascending ? (lhs.createdAt < rhs.createdAt) : (lhs.createdAt > rhs.createdAt)
            case .questionCount(let ascending):
                return ascending ? (lhs.questions.count < rhs.questions.count) : (lhs.questions.count > rhs.questions.count)
            }
        }
        return sortedPinnedProjects + sortedUnpinnedProjects
    }
}

