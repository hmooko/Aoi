import Foundation

protocol DeleteKanchuProjectUseCase {
    func execute(ids: [UUID]) async throws
}

final class DefaultDeleteKanchuProjectUseCase: DeleteKanchuProjectUseCase {
    private let kanchuRepository: KanchuProjectRepository

    init(kanchuRepository: KanchuProjectRepository) {
        self.kanchuRepository = kanchuRepository
    }

    func execute(ids: [UUID]) async throws {
        try await kanchuRepository.deleteProjects(ids)
    }
}

// MARK: - Mock Implementation for DefaultDeleteKanchuProjectUseCase
final class MockDefaultDeleteKanchuProjectUseCase: DeleteKanchuProjectUseCase {
    private let kanchuProjectRepository: KanchuProjectRepository
    var errorToThrow: Error?

    init(kanchuProjectRepository: KanchuProjectRepository, errorToThrow: Error? = nil) {
        self.kanchuProjectRepository = kanchuProjectRepository
        self.errorToThrow = errorToThrow
    }

    func execute(ids: [UUID]) async throws {
        if let error = errorToThrow {
            throw error
        }
        try await kanchuProjectRepository.deleteProjects(ids)
    }
}
