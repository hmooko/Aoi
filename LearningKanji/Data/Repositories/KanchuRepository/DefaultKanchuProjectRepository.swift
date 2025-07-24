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
                questions: project.questions
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
}
