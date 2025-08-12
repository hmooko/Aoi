//
//  ToggleKanchuProjectPinStateUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/25/25.
//

import Foundation

protocol ToggleKanchuProjectPinStateUseCase {
    func execute(project: KanchuProject) async throws -> KanchuProject
}

final class ToggleKanchuProjectPinStateService: ToggleKanchuProjectPinStateUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository

    init(kanchuProjectRepository: KanchuProjectRepository) {
        self.kanchuProjectRepository = kanchuProjectRepository
    }

    func execute(project: KanchuProject) async throws -> KanchuProject {
        let updatedProject = KanchuProject(
            id: project.id,
            name: project.name,
            createdAt: project.createdAt,
            questions: project.questions,
            isPinned: !project.isPinned
        )
        try await kanchuProjectRepository.updateKanchuProject(updatedProject)
        return updatedProject
    }
}

final class MockToggleKanchuProjectPinStateService: ToggleKanchuProjectPinStateUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository

    init(kanchuProjectRepository: KanchuProjectRepository) {
        self.kanchuProjectRepository = kanchuProjectRepository
    }

    func execute(project: KanchuProject) async throws -> KanchuProject {
        let updatedProject = KanchuProject(
            id: project.id,
            name: project.name,
            createdAt: project.createdAt,
            questions: project.questions,
            isPinned: !project.isPinned
        )
        try await kanchuProjectRepository.updateKanchuProject(updatedProject)
        return updatedProject
    }
}
