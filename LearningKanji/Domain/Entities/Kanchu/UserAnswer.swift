//
//  UserAnswer.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/**
 사용자의 답변과 그 결과를 담는 모델입니다.
 */
struct UserAnswer {
    /// 사용자가 답변한 문제
    let problem: KanchuProblem
    /// 사용자가 제출한 답변 문자열
    let submittedAnswer: String
    
    /// 사용자의 답변이 정답인지 여부
    var isCorrect: Bool {
        return problem.answer == submittedAnswer
    }
}
