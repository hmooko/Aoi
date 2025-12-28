//
//  DefaultCloudKitKanchuProjectRepository.swift
//  LearningKanji
//
//  Created by AI Assistant on 8/19/25.
//

import Foundation
import CloudKit

final class DefaultCloudKitKanchuProjectRepository: CloudKitKanchuProjectRepository {
    
    private let container = CKContainer(identifier: "iCloud.6554000732")
    private var database: CKDatabase {
        container.privateCloudDatabase
    }
    
    // MARK: - CloudKitKanchuProjectRepository Implementation
    
    func fetchAllProjects() async throws -> [KanchuProject] {
        let query = CKQuery(recordType: "KanchuProject", predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        let projectRecords = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CKRecord], Error>) in
            database.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: records ?? [])
                }
            }
        }
        
        // Fetch problems for each project
        var projects: [KanchuProject] = []
        
        for projectRecord in projectRecords {
            let problems = try await fetchProblems(for: projectRecord.recordID.recordName)
            let project = try projectRecord.toKanchuProject(with: problems)
            projects.append(project)
        }
        
        return projects
    }
    
    func saveProject(_ project: KanchuProject) async throws {
        try await saveProjects([project])
    }
    
    func saveProjects(_ projects: [KanchuProject]) async throws {
        var allRecords: [CKRecord] = []
        
        // Convert projects to CloudKit records
        for project in projects {
            let projectRecord = project.toCKRecord()
            allRecords.append(projectRecord)
            
            // Convert problems to CloudKit records
            for problem in project.questions {
                let problemRecord = problem.toCKRecord(projectId: project.id.uuidString)
                allRecords.append(problemRecord)
            }
        }
        
        // Save all records in batches (CloudKit has limits on batch operations)
        let batchSize = 200 // CloudKit batch limit is typically 400, but we use 200 for safety
        let batches = allRecords.chunked(into: batchSize)
        
        for batch in batches {
            try await saveBatch(batch)
        }
    }
    
    func deleteProject(withId projectId: String) async throws {
        // First, delete all problems associated with this project
        try await deleteProblems(for: projectId)
        
        // Then delete the project itself
        let projectRecordID = CKRecord.ID(recordName: projectId)
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            database.delete(withRecordID: projectRecordID) { _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func deleteAllProjects() async throws {
        let projects = try await fetchAllProjects()
        
        for project in projects {
            try await deleteProject(withId: project.id.uuidString)
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func fetchProblems(for projectId: String) async throws -> [KanchuProblem] {
        let predicate = NSPredicate(format: "projectId == %@", projectId)
        let query = CKQuery(recordType: "KanchuProblem", predicate: predicate)
        
        let problemRecords = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CKRecord], Error>) in
            database.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: records ?? [])
                }
            }
        }
        
        return try problemRecords.map { try $0.toKanchuProblem() }
    }
    
    private func deleteProblems(for projectId: String) async throws {
        let predicate = NSPredicate(format: "projectId == %@", projectId)
        let query = CKQuery(recordType: "KanchuProblem", predicate: predicate)
        
        let problemRecords = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[CKRecord], Error>) in
            database.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: records ?? [])
                }
            }
        }
        
        let recordIds = problemRecords.map { $0.recordID }
        if !recordIds.isEmpty {
            let batches = recordIds.chunked(into: 200)
            
            for batch in batches {
                try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                    database.modifyRecords(saving: [], deleting: batch, savePolicy: .changedKeys) { result in
                        switch result {
                        case .success(_):
                            continuation.resume()
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
    }
    
    private func saveBatch(_ records: [CKRecord]) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            database.modifyRecords(saving: records, deleting: [], savePolicy: .changedKeys) { result in
                switch result {
                case .success(_):
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - CloudKit Record Conversion Extensions

extension KanchuProject {
    func toCKRecord() -> CKRecord {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        let record = CKRecord(recordType: "KanchuProject", recordID: recordID)
        
        record.setValuesForKeys([
            "id": id.uuidString,
            "name": name,
            "createdAt": createdAt,
            "isPinned": isPinned
        ])
        
        return record
    }
}

extension KanchuProblem {
    func toCKRecord(projectId: String) -> CKRecord {
        let recordID = CKRecord.ID(recordName: id.uuidString)
        let record = CKRecord(recordType: "KanchuProblem", recordID: recordID)
        
        record.setValuesForKeys([
            "id": id.uuidString,
            "projectId": projectId,
            "type": type.rawValue,
            "sentence": sentence,
            "targetKanji": targetKanji,
            "options": options,
            "answer": answer,
            "targetWord": targetWord
        ])
        
        return record
    }
}

extension CKRecord {
    func toKanchuProject(with problems: [KanchuProblem]) throws -> KanchuProject {
        guard let idString = self["id"] as? String,
              let id = UUID(uuidString: idString),
              let name = self["name"] as? String,
              let createdAt = self["createdAt"] as? Date,
              let isPinned = self["isPinned"] as? Bool else {
            throw CloudKitKanchuProjectRepositoryError.invalidRecord("Failed to parse KanchuProject record")
        }
        
        return KanchuProject(
            id: id,
            name: name,
            createdAt: createdAt,
            questions: problems,
            isPinned: isPinned
        )
    }
    
    func toKanchuProblem() throws -> KanchuProblem {
        guard let idString = self["id"] as? String,
              let id = UUID(uuidString: idString),
              let typeRawValue = self["type"] as? String,
              let type = ProblemType(rawValue: typeRawValue),
              let sentence = self["sentence"] as? String,
              let targetKanji = self["targetKanji"] as? String,
              let options = self["options"] as? [String],
              let answer = self["answer"] as? String,
              let targetWord = self["targetWord"] as? String else {
            throw CloudKitKanchuProjectRepositoryError.invalidRecord("Failed to parse KanchuProblem record")
        }
        
        return KanchuProblem(
            id: id,
            type: type,
            sentence: sentence,
            targetKanji: targetKanji,
            options: options,
            answer: answer,
            targetWord: targetWord
        )
    }
}

// MARK: - Array Extension for Chunking

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Error Types

enum CloudKitKanchuProjectRepositoryError: Error, LocalizedError {
    case invalidRecord(String)
    case networkError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidRecord(let message):
            return "Invalid CloudKit record: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .unknownError:
            return "Unknown CloudKit error occurred"
        }
    }
}
