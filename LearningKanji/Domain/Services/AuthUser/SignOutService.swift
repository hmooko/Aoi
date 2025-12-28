//
//  SignOutUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation

protocol SignOutUseCase {
    func execute() throws
}

final class SignOutService: SignOutUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute() throws {
        try authRepository.signOut()
    }
}

// MARK: - Mock Service for Testing/Preview
final class MockSignOutService: SignOutUseCase {
    func execute() throws {
        // Mocking: 실제 로그아웃 동작 없이 성공 처리
        print("MockSignOutService: User signed out (mocked).")
    }
}
