//
//  LoginViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/14/25.
//

import Foundation
import AuthenticationServices
import FirebaseAuth
import CryptoKit
import FirebaseFirestore

extension LoginView {
    final class ViewModel: ObservableObject {
        private var currentNonce: String?
        
        func onRequest(request: ASAuthorizationAppleIDRequest) {
            let nonce = randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
        }
        
        func loginCompletion(authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                print(appleIDCredential.fullName?.description)
                print(appleIDCredential.email)
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                // Initialize a Firebase credential, including the user's full name.
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIDCredential.fullName)
                // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error.localizedDescription)
                        return
                    }
                    // User is signed in to Firebase with Apple.
                    // ...
                    print("success")
                    self.firstSignIn(authResult: authResult!, appleIDCredential: appleIDCredential)
                }
            }
        }
        
        private func firstSignIn(authResult: AuthDataResult, appleIDCredential: ASAuthorizationAppleIDCredential) {
            guard let isNew = authResult.additionalUserInfo?.isNewUser else {
                return
            }
            if isNew == false {
                print("재 로그인")
                return
            }
            
            print("첫 로그인")
            var name: String = ""
            if let fullName = appleIDCredential.fullName {
                name = (fullName.familyName ?? "") + (fullName.givenName ?? "")
            }
            
            let user = User(uid: authResult.user.uid, email: appleIDCredential.email!, name: name)
            
            let db = Firestore.firestore()
            do {
                try db.collection("users").document(authResult.user.uid).setData(from: user) { error in
                    if let error = error {
                        print("저장 실패: \(error.localizedDescription)")
                    } else {
                        print("저장 성공")
                    }
                }
            } catch {
                print("인코딩 실패: \(error.localizedDescription)")
            }
        }
        
        private func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            var randomBytes = [UInt8](repeating: 0, count: length)
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            
            let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            
            let nonce = randomBytes.map { byte in
                // Pick a random character from the set, wrapping around if needed.
                charset[Int(byte) % charset.count]
            }
            
            return String(nonce)
        }
        
        @available(iOS 13, *)
        private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                String(format: "%02x", $0)
            }.joined()
            
            return hashString
        }
    }
}
