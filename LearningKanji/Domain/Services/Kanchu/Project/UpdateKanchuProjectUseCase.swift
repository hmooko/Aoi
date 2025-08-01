//
//  UpdateKanchuProjectUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/25/25.
//

import Foundation

protocol UpdateKanchuProjectUseCase {
    func execute(project: KanchuProject) async throws
}

final class DefaultUpdateKanchuProjectUseCase: UpdateKanchuProjectUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository

    init(kanchuProjectRepository: KanchuProjectRepository) {
        self.kanchuProjectRepository = kanchuProjectRepository
    }

    func execute(project: KanchuProject) async throws {
        try await kanchuProjectRepository.updateKanchuProject(project)
    }
}

final class MockUpdateKanchuProjectUseCase: UpdateKanchuProjectUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository
    var executeCalled = false
    var executeProject: KanchuProject? = nil
    var executeError: Error? = nil

    init(kanchuProjectRepository: KanchuProjectRepository) {
        self.kanchuProjectRepository = kanchuProjectRepository
    }

    func execute(project: KanchuProject) async throws {
        executeCalled = true
        executeProject = project
        if let error = executeError {
            throw error
        }
        try await kanchuProjectRepository.updateKanchuProject(project)
    }
}
