//
//  KanchuRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/// 한자 퀴즈 문제를 가져오는 저장소 역할의 프로토콜입니다.
protocol GeminiKanchuQuizRepository {
    /// 주어진 한자 리스트와 문제 타입, 개수에 맞는 퀴즈 문제를 비동기적으로 반환합니다.
    /// - Parameters:
    ///   - kanjiList: 퀴즈 문제 생성을 위한 한자 목록입니다.
    ///   - problemType: 생성할 문제의 타입입니다.
    ///   - count: 생성할 문제의 개수입니다.
    /// - Returns: 생성된 퀴즈 문제 배열을 반환합니다.
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int, model: GeminiModel) async throws -> [KanchuProblem]
}

/// 네트워크 대신 미리 정의된 데이터를 반환하는 KanchuRepository의 mock 구현체입니다.
class GeminiMockKanjiQuizRepository: GeminiKanchuQuizRepository {
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int, model: GeminiModel) async throws -> [KanchuProblem] {
        /// 샘플 퀴즈 문제를 랜덤하게 반환합니다.
        
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
        
        // 문제 목록을 섞고 요청한 개수만큼 반환합니다.
        return Array(allProblems.shuffled().prefix(count))
    }
}
