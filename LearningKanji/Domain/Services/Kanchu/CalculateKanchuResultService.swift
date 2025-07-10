//
//  CalculateKanchuResultService.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

// --- 퀴즈 결과 계산 유즈케이스 ---
protocol CalculateKanchuProblemsResultUseCase {
    /// 사용자의 답변 목록을 바탕으로 최종 결과를 계산합니다.
    func execute(userAnswers: [UserAnswer]) -> QuizSessionResult
}

final class DefaultCalculateKanchuProblemsResultService: CalculateKanchuProblemsResultUseCase {
    func execute(userAnswers: [UserAnswer]) -> QuizSessionResult {
        return QuizSessionResult(userAnswers: userAnswers)
    }
}
