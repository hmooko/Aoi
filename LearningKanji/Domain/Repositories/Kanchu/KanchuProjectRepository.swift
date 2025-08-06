//
//  KanchuProjectRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 2025/07/23
//

import Foundation

protocol KanchuProjectRepository {
    func fetchAllProjects() async throws -> [KanchuProject]
    func insertProjects(_ projects: [KanchuProject]) async throws
    func deleteProjects(_ projectIds: [UUID]) async throws
    func updateKanchuProject(_ project: KanchuProject) async throws
}

enum KanchuProjectRepositoryError: Error {
    case ProjectNotFound
    
    var errorDescription: String? {
        switch self {
        case .ProjectNotFound:
            return "프로젝트를 찾을 수 없습니다."
        }
    }
}


