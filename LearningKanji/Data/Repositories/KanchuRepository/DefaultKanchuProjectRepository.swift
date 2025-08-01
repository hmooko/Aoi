//
//  DefaultKanchuProjectRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/23/25.
//

import Foundation
import SwiftData

final class DefaultKanchuProjectRepository: KanchuProjectRepository {
    
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAllProjects() async throws -> [KanchuProject] {
        let fetchDescriptor = FetchDescriptor<KanchuProjectDTO>()
        let dtos = try context.fetch(fetchDescriptor)
        return dtos.map { $0.toDomain(from: $0) }
    }
    
    func insertProjects(_ projects: [KanchuProject]) async throws {
        for project in projects {
            let dto = KanchuProjectDTO(
                id: project.id,
                name: project.name,
                createdAt: project.createdAt,
                questionCount: project.questionCount,
                questions: project.questions,
                isPinned: project.isPinned
            )
            context.insert(dto)
        }
        try context.save()
    }
    
    func deleteProjects(_ projectIds: [UUID]) async throws {
        guard !projectIds.isEmpty else { return }
        let predicate = #Predicate<KanchuProjectDTO> { projectIds.contains($0.id) }
        let fetchDescriptor = FetchDescriptor<KanchuProjectDTO>(predicate: predicate)
        let dtos = try context.fetch(fetchDescriptor)
        for dto in dtos {
            context.delete(dto)
        }
        try context.save()
    }

    func updateKanchuProject(_ project: KanchuProject) async throws {
        let predicate = #Predicate<KanchuProjectDTO> { $0.id == project.id }
        var fetchDescriptor = FetchDescriptor<KanchuProjectDTO>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        
        guard let dto = try context.fetch(fetchDescriptor).first else { return }
        
        dto.name = project.name
        dto.createdAt = project.createdAt
        dto.questionCount = project.questionCount
        dto.questions = project.questions
        dto.isPinned = project.isPinned
        
        try context.save()
    }
}

final class MockKanchuProjectRepository: KanchuProjectRepository {
    private var projects: [KanchuProject]
    var errorToThrow: Error? = nil

    init(initialProjects: [KanchuProject] = []) {
        self.projects = initialProjects
    }

    func fetchAllProjects() async throws -> [KanchuProject] {
        if let error = errorToThrow {
            throw error
        }
        return projects
    }

    func insertProjects(_ newProjects: [KanchuProject]) async throws {
        if let error = errorToThrow {
            throw error
        }
        projects.append(contentsOf: newProjects)
    }

    func deleteProjects(_ projectIds: [UUID]) async throws {
        if let error = errorToThrow {
            throw error
        }
        projects.removeAll { projectIds.contains($0.id) }
    }

    func updateKanchuProject(_ updatedProject: KanchuProject) async throws {
        if let error = errorToThrow {
            throw error
        }
        if let index = projects.firstIndex(where: { $0.id == updatedProject.id }) {
            projects[index] = updatedProject
        }
    }
}

