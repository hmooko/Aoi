import Foundation

protocol InsertKanchuProjectUseCase {
    func execute(projects: [KanchuProject]) async throws
}

final class DefaultInsertKanchuProjectUseCase: InsertKanchuProjectUseCase {
    private let kanchuRepository: KanchuProjectRepository

    init(kanchuRepository: KanchuProjectRepository) {
        self.kanchuRepository = kanchuRepository
    }

    func execute(projects: [KanchuProject]) async throws {
        try await kanchuRepository.insertProjects(projects)
    }
}

final class MockInsertKanchuProjectUseCase: InsertKanchuProjectUseCase {
    private(set) var receivedProjects: [KanchuProject]?
    var errorToThrow: Error?
    
    init(errorToThrow: Error? = nil) {
        self.errorToThrow = errorToThrow
    }

    func execute(projects: [KanchuProject]) async throws {
        receivedProjects = projects
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
    }
}
