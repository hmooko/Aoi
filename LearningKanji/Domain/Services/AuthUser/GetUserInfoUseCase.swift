//
//  GetUserInfoUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation

// Use Case 프로토콜
protocol GetUserInfoUseCase {
    func execute(uid: String) async throws -> AoiUser?
}

// Use Case 구현체 (Service)
final class DefaultGetUserInfoService: GetUserInfoUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(uid: String) async throws -> AoiUser? {
        return try await userRepository.getUser(uid: uid)
    }
}

// MARK: - Mock Service for Testing/Preview
final class MockGetUserInfoService: GetUserInfoUseCase {
    private var mockUser: AoiUser?
    
    init(mockUser: AoiUser? = nil) {
        // 기본 모의 사용자: Firebase Auth에서 제공하는 UID를 가정합니다.
        self.mockUser = mockUser ?? AoiUser(uid: "mock_user_123", email: "mock@example.com", name: "Mock User", aiUsageCount: 10)
    }
    
    func execute(uid: String) async throws -> AoiUser? {
        // 제공된 UID와 모의 UID가 일치하면 모의 사용자 반환
        if uid == mockUser?.uid {
            return mockUser
        } else {
            // 일치하지 않으면 nil 또는 에러 반환 (테스트 시나리오에 따라 조절)
            return nil
        }
    }
}
