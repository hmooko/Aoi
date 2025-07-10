//
//  KanchuRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

protocol KanchuRepository {
    /// 지정된 학습 대상, 문제 유형, 문항 수에 맞는 퀴즈 문제 목록을 가져옵니다.
    /// - Parameters:
    ///     -   target: 학습 대상 (예: .elementary(grade: 1))
    ///     -   problemType: 문제 유형 (예: .findReading)
    ///     -   count: 가져올 문제의 수
    /// - Returns: 퀴즈 문제 배열
    func fetchProblems(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanjiProblem]
}

class MockKanjiRepository: KanchuRepository {
    func fetchProblems(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanjiProblem] {
        // 네트워크 통신을 시뮬레이션하기 위해 1초간 지연시킵니다.
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // 실제로는 target과 problemType에 맞는 데이터를 필터링해야 합니다.
        // 여기서는 미리 정의된 전체 문제 목록에서 랜덤으로 반환합니다.
        let allProblems: [KanjiProblem] = [
            .init(id: UUID(), type: .findReading, sentence: "これは[複雑]な問題です。", targetWord: "複雑", options: ["ふくざつ", "ふくさつ", "ふうざつ"], answer: "ふくざつ"),
            .init(id: UUID(), type: .findKanji, sentence: "友達を[しょうかい]します。", targetWord: "しょうかい", options: ["紹介", "召会", "商会"], answer: "紹介"),
            .init(id: UUID(), type: .findReading, sentence: "日本の[言語]は美しいです。", targetWord: "言語", options: ["げんご", "ことば", "げんごう"], answer: "げんご"),
            .init(id: UUID(), type: .findKanji, sentence: "毎朝、公園を[さんぽ]します。", targetWord: "さんぽ", options: ["散歩", "三歩", "参歩"], answer: "散歩"),
            .init(id: UUID(), type: .findReading, sentence: "面白い[話]を聞きました。", targetWord: "話", options: ["はなし", "こと", "わ"], answer: "はなし"),
            .init(id: UUID(), type: .findKanji, sentence: "事情が[ふくざつ]に絡んでいます。", targetWord: "ふくざつ", options: ["複雑", "複集", "複離"], answer: "複雑")
        ]
        
        return Array(allProblems.shuffled().prefix(count))
    }
}
