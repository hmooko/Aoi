//
//  User.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/13/25.
//

import Foundation

// Firestore에 저장될 사용자 모델입니다.
struct AoiUser: Codable, Identifiable {
    var id: String { uid }
    
    let uid: String
    let email: String
    let name: String
    let aiUsageCount: Int // AI 사용 가능 횟수
}
