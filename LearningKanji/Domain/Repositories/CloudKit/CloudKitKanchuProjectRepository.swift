//
//  CloudKitKanchuProjectRepository.swift
//  LearningKanji
//
//  Created by AI Assistant on 8/19/25.
//

import Foundation

/// A protocol defining the interface for managing KanchuProject entities in CloudKit.
protocol CloudKitKanchuProjectRepository {
    /// Fetches all Kanchu projects from CloudKit.
    /// - Returns: An array of KanchuProject objects.
    /// - Throws: An error if the fetch operation fails.
    func fetchAllProjects() async throws -> [KanchuProject]

    /// Saves a single Kanchu project to CloudKit.
    /// - Parameter project: The KanchuProject to save.
    /// - Throws: An error if the save operation fails.
    func saveProject(_ project: KanchuProject) async throws

    /// Saves multiple Kanchu projects to CloudKit.
    /// - Parameter projects: An array of KanchuProjects to save.
    /// - Throws: An error if the save operation fails.
    func saveProjects(_ projects: [KanchuProject]) async throws

    /// Deletes a Kanchu project from CloudKit using its ID.
    /// - Parameter projectId: The ID of the project to delete.
    /// - Throws: An error if the delete operation fails.
    func deleteProject(withId projectId: String) async throws
    
    /// Deletes all Kanchu projects from CloudKit.
    /// This is a destructive operation and should be used with caution.
    /// - Throws: An error if the delete operation fails.
    func deleteAllProjects() async throws
}
