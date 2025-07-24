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
    var id: UUID
    
    /// 프로젝트 이름 (예: "초1 - 올바른 발음 구하기")
    var name: String
    
    /// 프로젝트 생성 일자
    var createdAt: Date
    
    /// 프로젝트에 포함된 문제의 총 개수
    var questionCount: Int
    
    /// 프로젝트에 포함된 실제 문제들의 배열
    var questions: [KanchuProblem]
    
    init(id: UUID, name: String, createdAt: Date, questionCount: Int, questions: [KanchuProblem]) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.questionCount = questionCount
        self.questions = questions
    }
}

extension KanchuProjectDTO {
    func toDomain(from pr: KanchuProjectDTO) -> KanchuProject {
        .init(id: pr.id, name: pr.name, createdAt: pr.createdAt, questionCount: pr.questionCount, questions: pr.questions)
    }
}
