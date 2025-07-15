//
//  Kanchu.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/// 퀴즈 문제의 유형을 정의합니다.
enum ProblemType: String, CaseIterable {
    case findReading = "올바른 발음 구하기"
    case findKanji = "올바른 한자 표기 구하기"
    case fillReading = "발음에 해당하는 한자 표기 구하기"
}

/// 학습 대상을 나타내는 모델입니다. 학년 또는 북마크 그룹을 포함할 수 있습니다.
enum QuizTarget: Hashable {
    case elementary(grade: Grade)
    case middleSchool(index: Int)
    case bookmark(id: Int, name: String) // 북마크 그룹
    
    func getString() -> String {
        switch self {
        case .elementary(grade: let grade):
            return "\(grade.rawValue)"
        case .middleSchool(index: let index):
            return "중\(index)"
        case .bookmark(id: _, name: let name):
            return name
        }
    }
}

/// 한자 퀴즈 문제 하나를 나타내는 모델입니다.
struct KanchuProblem: Identifiable {
    let id: UUID
    let type: ProblemType
    let sentence: String // 예: "これは[複雑]な問題です。"
    let targetKanji: String // 예: "複雑" 또는 "しょうかい"
    let options: [String]
    let answer: String
    let targetword: String 
}

/// 사용자의 답변과 그 결과를 담는 모델입니다.
struct UserAnswer {
    let problem: KanchuProblem
    let submittedAnswer: String
    
    var isCorrect: Bool {
        return problem.answer == submittedAnswer
    }
}

/// 퀴즈 세션의 최종 결과를 요약하는 모델입니다.
struct QuizSessionResult {
    let userAnswers: [UserAnswer]
    
    var totalProblems: Int { userAnswers.count }
    var correctAnswers: Int { userAnswers.filter { $0.isCorrect }.count }
    var score: Double {
        guard totalProblems > 0 else { return 0 }
        return (Double(correctAnswers) / Double(totalProblems)) * 100
    }
}

