//
//  AuthRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation

import Foundation
import AuthenticationServices

protocol AuthRepository {
    func signInWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String) async throws -> (uid: String, isNewUser: Bool)
    func getCurrentUserUID() -> String? 
    func signOut() throws
}
