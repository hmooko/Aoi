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
    private let kanchuProjectRepository: KanchuProjectRepository
    var errorToThrow: Error?
    
    init(kanchuProjectRepository: KanchuProjectRepository, errorToThrow: Error? = nil) {
        self.kanchuProjectRepository = kanchuProjectRepository
        self.errorToThrow = errorToThrow
    }

    func execute(projects: [KanchuProject]) async throws {
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        try await kanchuProjectRepository.insertProjects(projects)
    }
}
