//
//  SignInWithAppleUseService.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation
import AuthenticationServices

protocol SignInWithAppleUseCase {
    func execute(authorization: ASAuthorization, nonce: String) async throws
}

enum SignInWithAppleUseCaseError: Error, LocalizedError {
    case invalidCredential
    case emailNotProvided
    case invalidState

    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "잘못된 Apple ID 자격 증명입니다."
        case .emailNotProvided:
            return "가입 시 이메일이 제공되지 않았습니다. Apple 계정 설정에서 앱과의 이메일 공유를 허용해주세요."
        case .invalidState:
            return "잘못된 상태: 로그인 요청이 전송되지 않았는데 콜백이 수신되었습니다."
        }
    }
}

final class SignInWithAppleService: SignInWithAppleUseCase {
    private let authRepository: AuthRepository
    private let userRepository: UserRepository

    init(authRepository: AuthRepository, userRepository: UserRepository) {
        self.authRepository = authRepository // 수정: 'auth'에서 'authRepository'로 변경
        self.userRepository = userRepository
    }

    func execute(authorization: ASAuthorization, nonce: String) async throws {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            throw SignInWithAppleUseCaseError.invalidCredential
        }

        // Firebase Auth에 로그인하고 UID를 받습니다. isNewUser 플래그는 더 이상 직접 사용되지 않습니다.
        let (uid, _) = try await authRepository.signInWithApple(credential: appleIDCredential, nonce: nonce)

        // Firestore에 해당 사용자 문서가 존재하는지 확인합니다.
        let existingUserInFirestore = try await userRepository.getUser(uid: uid)

        // 만약 Firestore에 사용자 문서가 없다면 새로 생성합니다.
        // 이는 인증 시스템에서 새로운 사용자이거나, 기존 사용자이지만 어떤 이유로 Firestore 문서가 누락된 경우를 모두 처리합니다.
        if existingUserInFirestore == nil {
            guard let email = appleIDCredential.email else {
                // 이메일이 제공되지 않았다면 에러를 발생시킵니다.
                // 이는 새 사용자이거나, 기존 사용자이지만 이메일 공유를 취소한 경우 발생할 수 있습니다.
                throw SignInWithAppleUseCaseError.emailNotProvided
            }
            
            let name: String
            if let fullName = appleIDCredential.fullName {
                name = [fullName.givenName, fullName.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
            } else {
                name = "" // 이름 정보가 없을 경우 빈 문자열로 저장
            }
            
            let newUser = AoiUser(uid: uid, email: email, name: name, aiUsageCount: 10)
            try await userRepository.createUser(user: newUser)
        }
        // Firestore에 사용자 문서가 이미 존재한다면 별도의 작업을 수행할 필요가 없습니다.
        // 필요에 따라 여기에 사용자 정보 업데이트 로직을 추가할 수 있습니다 (예: 이름, 이메일 변경 등).
    }
}

final class MockSignInWithAppleService: SignInWithAppleUseCase {
    func execute(authorization: ASAuthorization, nonce: String) async throws {
        // 테스트용 Mock 구현
    }
}
