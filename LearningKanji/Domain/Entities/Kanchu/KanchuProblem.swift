//
//  KanchuProblem.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/**
 한자 퀴즈 문제 하나를 나타내는 모델입니다.
 
 Codable 프로토콜을 채택하여 KanchuProject와 같은 다른 Codable 타입에서 사용할 수 있습니다.
 */
struct KanchuProblem: Identifiable, Codable, Hashable {
    /// 문제 고유 식별자
    let id: UUID
    /// 문제 유형
    let type: ProblemType
    /// 문제 문장 예: "これは[複雑]な問題です。"
    let sentence: String
    /// 문제 대상 한자 또는 발음 예: "複雑" 또는 "しょうかい"
    let targetKanji: String
    /// 선택지 배열
    let options: [String]
    /// 정답
    let answer: String
    /// 문제 대상 단어
    let targetWord: String 
}

