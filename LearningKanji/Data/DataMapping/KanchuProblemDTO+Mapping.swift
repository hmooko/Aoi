//
//  KanchuProblemDTO.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/2/25.
//

import Foundation
import SwiftData

@Model
final class KanchuProblemDTO {
    
    /// 문제 고유 식별자
    var id: UUID = UUID()
    /// 문제 유형
    var typeRawValue: String = ""
    /// 문제 문장 예: "これは[複雑]な問題です。"
    var sentence: String = ""
    /// 문제 대상 한자 또는 발음 예: "複雑" 또는 "しょうかい"
    var targetKanji: String = ""
    /// 선택지 배열
    var options: [String] = []
    /// 정답
    var answer: String = ""
    /// 문제 대상 단어
    var targetWord: String = ""
    
    var project: KanchuProjectDTO?
    
    init(id: UUID, typeRawValue: String, sentence: String, targetKanji: String, options: [String], answer: String, targetWord: String, project: KanchuProjectDTO) {
        self.id = id
        self.typeRawValue = typeRawValue
        self.sentence = sentence
        self.targetKanji = targetKanji
        self.options = options
        self.answer = answer
        self.targetWord = targetWord
        self.project = project
    }
}


extension KanchuProblemDTO {
    func toDomain() -> KanchuProblem {
        .init(id: self.id, type: ProblemType.init(rawValue: self.typeRawValue) ?? .fillReading, sentence: self.sentence, targetKanji: self.targetKanji, options: self.options, answer: self.answer, targetWord: self.targetWord)
    }
}

extension KanchuProblem {
    func toDTO(project: KanchuProjectDTO) -> KanchuProblemDTO {
        .init(id: self.id,
              typeRawValue: self.type.rawValue,
              sentence: self.sentence,
              targetKanji: self.targetKanji,
              options: self.options,
              answer: self.answer,
              targetWord: self.targetWord,
              project: project) 
    }
}

