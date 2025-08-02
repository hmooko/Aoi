//
//  KanchuProjectDTO.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/25.
//

import Foundation
import SwiftData

@Model
final class KanchuProjectDTO {
    /// 프로젝트의 고유 식별자
    @Attribute(.unique) var id: UUID
    
    /// 프로젝트 이름 (예: "초1 - 올바른 발음 구하기")
    var name: String
    
    /// 프로젝트 생성 일자
    var createdAt: Date
    
    /// 프로젝트에 포함된 문제의 총 개수
    var questionCount: Int
    
    /// 프로젝트에 포함된 실제 문제들의 배열
    @Relationship(deleteRule: .cascade, inverse: \KanchuProblemDTO.project)
    var questions: [KanchuProblemDTO]
    
    // 프로젝트 고정 여부
    var isPinned: Bool
    
    init(id: UUID, name: String, createdAt: Date, questionCount: Int, questions: [KanchuProblemDTO], isPinned: Bool) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.questionCount = questionCount
        self.questions = questions
        self.isPinned = isPinned
    }
}

@Model
final class KanchuProblemDTO {
    
    var project: KanchuProjectDTO
    /// 문제 고유 식별자
    @Attribute(.unique) var id: UUID
    /// 문제 유형
    var type: ProblemType
    /// 문제 문장 예: "これは[複雑]な問題です。"
    var sentence: String
    /// 문제 대상 한자 또는 발음 예: "複雑" 또는 "しょうかい"
    var targetKanji: String
    /// 선택지 배열
    var options: [String]
    /// 정답
    var answer: String
    /// 문제 대상 단어
    var targetWord: String
    
    init(id: UUID, projectId: UUID, type: ProblemType, sentence: String, targetKanji: String, options: [String], answer: String, targetWord: String) {
        self.id = id
        self.projectId = projectId
        self.type = type
        self.sentence = sentence
        self.targetKanji = targetKanji
        self.options = options
        self.answer = answer
        self.targetWord = targetWord
    }
}

extension KanchuProjectDTO {
    func toDomain() -> KanchuProject {
        let problems: [KanchuProblem] = self.questions.map { $0.toDomain() }
        return .init(id: self.id, name: self.name, createdAt: self.createdAt, questionCount: self.questionCount, questions: problems, isPinned: self.isPinned)
    }
}

extension KanchuProblemDTO {
    func toDomain() -> KanchuProblem {
        .init(id: self.id, type: self.type, sentence: self.sentence, targetKanji: self.targetKanji, options: self.options, answer: self.answer, targetWord: self.targetWord)
    }
}

extension KanchuProblem {
    func toDTO(projectId: UUID) -> KanchuProblemDTO {
        .init(id: self.id,
              projectId: projectId,
              type: self.type,
              sentence: self.sentence,
              targetKanji: self.targetKanji,
              options: self.options,
              answer: self.answer,
              targetWord: self.targetWord)
    }
}
