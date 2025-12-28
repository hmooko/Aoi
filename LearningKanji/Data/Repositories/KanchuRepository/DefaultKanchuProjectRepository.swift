//
//  DefaultKanchuProjectRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/23/25.
//

import Foundation
import SwiftData
import os

enum KanchuProjectRepositoryError: Error, LocalizedError {
    case ProjectNotFound
    
    var errorDescription: String? {
        switch self {
        case .ProjectNotFound:
            return "프로젝트를 찾을 수 없습니다."
        }
    }
}


@MainActor
final class DefaultKanchuProjectRepository: KanchuProjectRepository {

    private let logger = Logger(subsystem: "com.aoi.LearningKanji", category: "DefaultKanchuProjectRepository")
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        logger.info("DefaultKanchuProjectRepository initialized.")
    }

    func fetchAllProjects() async throws -> [KanchuProject] {
        logger.info("Fetching all Kanchu projects.")
        do {
            let descriptor = FetchDescriptor<KanchuProjectDTO>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
            let projectDTOs = try context.fetch(descriptor)
            logger.info("Fetched \(projectDTOs.count) projects.")
            return projectDTOs.map { $0.toDomain() }
        } catch {
            logger.error("Failed to fetch all projects: \(error.localizedDescription)")
            throw error
        }
    }
    
    func insertProjects(_ projects: [KanchuProject]) async throws {
        logger.info("Inserting \(projects.count) new projects.")
        for project in projects {
            let projectDTO = project.toDTO()
            context.insert(projectDTO)
        }
        logger.info("Successfully inserted \(projects.count) projects.")
    }
    
    func deleteProjects(_ projectIds: [UUID]) async throws {
        logger.info("Deleting \(projectIds.count) projects.")
        do {
            let predicate = #Predicate<KanchuProjectDTO> { projectDTO in
                projectIds.contains(projectDTO.id)
            }
            try context.delete(model: KanchuProjectDTO.self, where: predicate)
            logger.info("Successfully deleted projects with IDs: \(projectIds.map { $0.uuidString }.joined(separator: ", "))")
        } catch {
            logger.error("Failed to delete projects: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteAllProjects() async throws {
        logger.info("Deleting all projects.")
        do {
            try context.delete(model: KanchuProjectDTO.self)
            logger.info("Successfully deleted all projects.")
        } catch {
            logger.error("Failed to delete all projects: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateKanchuProject(_ project: KanchuProject) async throws {
        logger.info("Updating project with ID: \(project.id.uuidString)")
        do {
            let predicate = #Predicate<KanchuProjectDTO> { $0.id == project.id }
            let descriptor = FetchDescriptor(predicate: predicate)
            
            guard let projectToUpdate = try context.fetch(descriptor).first else {
                logger.warning("Project with ID \(project.id.uuidString) not found for update.")
                throw KanchuProjectRepositoryError.ProjectNotFound
            }
            
            projectToUpdate.name = project.name
            projectToUpdate.isPinned = project.isPinned
            
            if let existingQuestions = projectToUpdate.questions {
                logger.debug("Deleting \(existingQuestions.count) old questions for project \(project.id.uuidString).")
                for question in existingQuestions {
                    context.delete(question)
                }
            }
            
            let newQuestionDTOs = project.questions.map { $0.toDTO(project: projectToUpdate) }
            projectToUpdate.questions = newQuestionDTOs
            logger.debug("Adding \(newQuestionDTOs.count) new questions for project \(project.id.uuidString).")
            logger.info("Successfully updated project with ID: \(project.id.uuidString).")
        } catch {
            logger.error("Failed to update project \(project.id.uuidString): \(error.localizedDescription)")
            throw error
        }
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
    
    func deleteAllProjects() async throws {
        if let error = errorToThrow {
            throw error
        }
        projects.removeAll()
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
