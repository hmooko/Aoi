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
    private(set) var receivedIds: [[UUID]] = []
    var errorToThrow: Error?

    init(errorToThrow: Error? = nil) {
        self.errorToThrow = errorToThrow
    }

    func execute(ids: [UUID]) async throws {
        if let error = errorToThrow {
            throw error
        }
        receivedIds.append(ids)
    }
}
