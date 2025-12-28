//
//  DefaultUserRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import Foundation
import FirebaseFirestore

enum FirestoreCollection: String {
    case user = "user"
}

final class DefaultUserRepository: UserRepository {
    private let db = Firestore.firestore()

    func createUser(user: AoiUser) async throws {
        // 모든 AoiUser 속성을 Firestore에 저장하도록 수정합니다.
        try db.collection(FirestoreCollection.user.rawValue).document(user.uid).setData(from: user)
    }

    func getUser(uid: String) async throws -> AoiUser? {
        let document = try await db.collection(FirestoreCollection.user.rawValue).document(uid).getDocument()
        guard document.exists else { return nil }
    
        return try document.data(as: AoiUser.self)
    }
}

