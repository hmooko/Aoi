//
//  GetCurrentUserUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation

protocol GetCurrentUserUseCase {
    func execute() -> String?
}

final class DefaultGetCurrentUserService: GetCurrentUserUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() -> String? {
        return authRepository.getCurrentUserUID()
    }
}

// MARK: - Mock Service for Testing/Preview
final class MockGetCurrentUserService: GetCurrentUserUseCase {
    var mockUID: String?

    init(mockUID: String? = "mock_user_123") {
        self.mockUID = mockUID
    }

    func execute() -> String? {
        return mockUID
    }
}
