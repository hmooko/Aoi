//
//  GetKanchuProblemsService.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

// --- 퀴즈 문제 목록 가져오기 유즈케이스 ---
protocol GetKanchuProblemsUseCase {
    /// 퀴즈를 시작하기 위해 문제 목록을 가져옵니다.
    func execute(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanjiProblem]
}

final class DefaultGetKanchuProblemsService: GetKanchuProblemsUseCase {
    private let kanchuRepository: KanchuRepository
    
    init(kanchuRepository: KanchuRepository) {
        self.kanchuRepository = kanchuRepository
    }
    
    func execute(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanjiProblem] {
        // Repository를 통해 문제 목록을 가져옵니다.
        // 실제 네트워크 통신이나 데이터베이스 조회는 Repository 구현체에서 담당합니다.
        return try await kanchuRepository.fetchProblems(target: target, problemType: problemType, count: count)
    }
}
