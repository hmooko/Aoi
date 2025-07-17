//
//  KanchuRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

enum GeminiError: Error, LocalizedError {
    case apiKeyNotFound
    case invalidURL
    case requestEncodingFailed(Error)
    case responseDecodingFailed(Error)
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .apiKeyNotFound: return "API 키를 찾을 수 없습니다. GenerativeAI-Info.plist를 확인하세요."
        case .invalidURL: return "잘못된 API URL입니다."
        case .requestEncodingFailed: return "요청 데이터를 인코딩하는 데 실패했습니다."
        case .responseDecodingFailed: return "응답 데이터를 디코딩하는 데 실패했습니다."
        case .apiError(let message): return "API 에러: \(message)"
        }
    }
}

enum KanchuRepositoryError: Error, LocalizedError {
    case kanjiListLessThanCount
    case kanjiFetchingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .kanjiListLessThanCount: return "kanjiList의 길이가 퀴즈 문제로 필요한 수보다 적습니다."
        case .kanjiFetchingFailed: return "퀴즈를 만들 한자를 가져오는 데 실패했습니다."
        }
    }
}

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
