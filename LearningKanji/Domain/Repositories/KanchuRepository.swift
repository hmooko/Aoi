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
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int) async throws -> [KanchuProblem]
}

class MockKanjiRepository: KanchuRepository {
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int) async throws -> [KanchuProblem] {
        // 네트워크 통신을 시뮬레이션하기 위해 1초간 지연시킵니다.
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // 실제로는 target과 problemType에 맞는 데이터를 필터링해야 합니다.
        // 여기서는 미리 정의된 전체 문제 목록에서 랜덤으로 반환합니다.
        let allProblems: [KanchuProblem] = [
            .init(id: UUID(), type: .findReading, sentence: "これは[複雑]な問題です。", targetKanji: "複雑", options: ["ふくざつ", "ふくさつ", "ふうざつ"], answer: "ふくざつ", targetWord: "複雑"),
            .init(id: UUID(), type: .findKanji, sentence: "友達を[しょうかい]します。", targetKanji: "しょうかい", options: ["紹介", "召会", "商会"], answer: "紹介", targetWord: "しょうかい"),
            .init(id: UUID(), type: .findReading, sentence: "日本の[言語]は美しいです。", targetKanji: "言語", options: ["げんご", "ことば", "げんごう"], answer: "げんご", targetWord: "言語"),
            .init(id: UUID(), type: .findKanji, sentence: "毎朝、公園を[さんぽ]します。", targetKanji: "さんぽ", options: ["散歩", "三歩", "参歩"], answer: "散歩", targetWord: "さんぽ"),
            .init(id: UUID(), type: .findReading, sentence: "面白い[話]を聞きました。", targetKanji: "話", options: ["はなし", "こと", "わ"], answer: "はなし", targetWord: "話"),
            .init(id: UUID(), type: .findKanji, sentence: "事情が[ふくざつ]に絡んでいます。", targetKanji: "ふくざつ", options: ["複雑", "複集", "複離"], answer: "複雑", targetWord: "ふくざつ")
        ]
        
        return Array(allProblems.shuffled().prefix(count))
    }
}
