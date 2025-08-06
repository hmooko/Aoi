//
//  DefaultKanchuProjectRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/23/25.
//

import Foundation
import SwiftData

@MainActor
final class DefaultKanchuProjectRepository: KanchuProjectRepository {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAllProjects() async throws -> [KanchuProject] {
        let descriptor = FetchDescriptor<KanchuProjectDTO>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        let projectDTOs = try context.fetch(descriptor)
        return projectDTOs.map { $0.toDomain() }
    }
    
    func insertProjects(_ projects: [KanchuProject]) async throws {
        for project in projects {
            let projectDTO = project.toDTO()
            context.insert(projectDTO)
        }
    }
    
    func deleteProjects(_ projectIds: [UUID]) async throws {
        let predicate = #Predicate<KanchuProjectDTO> { projectDTO in
            projectIds.contains(projectDTO.id)
        }
        try context.delete(model: KanchuProjectDTO.self, where: predicate)
    }
    
    func updateKanchuProject(_ project: KanchuProject) async throws {
        let predicate = #Predicate<KanchuProjectDTO> { $0.id == project.id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        guard let projectToUpdate = try context.fetch(descriptor).first else {
            throw KanchuProjectRepositoryError.ProjectNotFound
        }
        
        projectToUpdate.name = project.name
        projectToUpdate.isPinned = project.isPinned
        
        if let existingQuestions = projectToUpdate.questions {
            for question in existingQuestions {
                context.delete(question)
            }
        }
        
        let newQuestionDTOs = project.questions.map { $0.toDTO(project: projectToUpdate) }
        projectToUpdate.questions = newQuestionDTOs
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
