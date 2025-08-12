//
//  DefaultAuthRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation
import AuthenticationServices
import FirebaseAuth

final class DefaultAuthRepository: AuthRepository {
    func signInWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws -> (uid: String, isNewUser: Bool) {
        guard let appleIDToken = credential.identityToken else {
            throw NSError(domain: "DefaultAuthRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "ID 토큰을 가져올 수 없습니다."])
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw NSError(domain: "DefaultAuthRepository", code: -2, userInfo: [NSLocalizedDescriptionKey: "토큰 데이터를 문자열로 변환할 수 없습니다."])
        }

        let firebaseCredential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: credential.fullName)
        
        let authResult = try await Auth.auth().signIn(with: firebaseCredential)
        
        let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
        let uid = authResult.user.uid
        
        return (uid, isNewUser)
    }

    // AuthRepository 프로토콜 구현: 현재 사용자 UID 반환
    func getCurrentUserUID() -> String? {
        return Auth.auth().currentUser?.uid
    }

    // AuthRepository 프로토콜 구현: 로그아웃
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

