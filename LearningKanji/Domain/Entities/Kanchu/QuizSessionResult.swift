//
//  QuizSessionResult.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/**
 퀴즈 세션의 최종 결과를 요약하는 모델입니다.
 */
struct QuizSessionResult {
    /// 사용자의 모든 답변 목록
    let userAnswers: [UserAnswer]
    
    /// 총 문제 수
    var totalProblems: Int { userAnswers.count }
    /// 정답 개수
    var correctAnswers: Int { userAnswers.filter { $0.isCorrect }.count }
    /// 점수 (정답 비율, 0~100)
    var score: Double {
        guard totalProblems > 0 else { return 0 }
        return (Double(correctAnswers) / Double(totalProblems)) * 100
    }
}
