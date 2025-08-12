//
//  RenameKanchuProjectUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/25/25.
//

import Foundation

protocol RenameKanchuProjectUseCase {
    func execute(project: KanchuProject, newName: String) async throws -> KanchuProject
}

final class RenameKanchuProjectService: RenameKanchuProjectUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository

    init(kanchuProjectRepository: KanchuProjectRepository) {
        self.kanchuProjectRepository = kanchuProjectRepository
    }

    func execute(project: KanchuProject, newName: String) async throws -> KanchuProject {
        let updatedProject = KanchuProject(
            id: project.id,
            name: newName,
            createdAt: project.createdAt,
            questions: project.questions,
            isPinned: project.isPinned
        )
        try await kanchuProjectRepository.updateKanchuProject(updatedProject)
        return updatedProject
    }
}

final class MockRenameKanchuProjectService: RenameKanchuProjectUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository

    init(kanchuProjectRepository: KanchuProjectRepository) {
        self.kanchuProjectRepository = kanchuProjectRepository
    }

    func execute(project: KanchuProject, newName: String) async throws -> KanchuProject {
        let updatedProject = KanchuProject(
            id: project.id,
            name: newName,
            createdAt: project.createdAt,
            questions: project.questions,
            isPinned: project.isPinned
        )
        // In a real mock scenario, you might not call the repository
        // but for consistency with the existing mock setup, we forward the call.
        try await kanchuProjectRepository.updateKanchuProject(updatedProject)
        return updatedProject
    }
}
