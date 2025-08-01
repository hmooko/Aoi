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
