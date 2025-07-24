//
//  KanchuRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/// Gemini API와 통신 시 발생할 수 있는 에러를 정의한 열거형입니다.
enum GeminiError: Error, LocalizedError {
    /// API 키를 찾을 수 없는 경우 발생하는 에러입니다.
    case apiKeyNotFound
    /// 잘못된 API URL인 경우 발생하는 에러입니다.
    case invalidURL
    /// 요청 데이터를 인코딩하는 데 실패했을 때 발생하는 에러입니다.
    case requestEncodingFailed(Error)
    /// 응답 데이터를 디코딩하는 데 실패했을 때 발생하는 에러입니다.
    case responseDecodingFailed(Error)
    /// API 호출 중 발생한 에러 메시지를 포함하는 에러입니다.
    case apiError(String)

    /// 각 에러에 대한 사용자 친화적인 설명을 반환합니다.
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

/// KanchuRepository 관련 에러를 정의한 열거형입니다.
enum KanchuQuizRepositoryError: Error, LocalizedError {
    /// kanjiList의 길이가 퀴즈 문제로 필요한 수보다 적을 때 발생하는 에러입니다.
    case kanjiListLessThanCount
    /// 한자 데이터를 가져오는 중 실패했을 때 발생하는 에러입니다.
    case kanjiFetchingFailed(Error)
    
    /// 각 에러에 대한 사용자 친화적인 설명을 반환합니다.
    var errorDescription: String? {
        switch self {
        case .kanjiListLessThanCount: return "kanjiList의 길이가 퀴즈 문제로 필요한 수보다 적습니다."
        case .kanjiFetchingFailed: return "퀴즈를 만들 한자를 가져오는 데 실패했습니다."
        }
    }
}

/// 한자 퀴즈 문제를 가져오는 저장소 역할의 프로토콜입니다.
protocol KanchuQuizRepository {
    /// 주어진 한자 리스트와 문제 타입, 개수에 맞는 퀴즈 문제를 비동기적으로 반환합니다.
    /// - Parameters:
    ///   - kanjiList: 퀴즈 문제 생성을 위한 한자 목록입니다.
    ///   - problemType: 생성할 문제의 타입입니다.
    ///   - count: 생성할 문제의 개수입니다.
    /// - Returns: 생성된 퀴즈 문제 배열을 반환합니다.
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int) async throws -> [KanchuProblem]
}

/// 네트워크 대신 미리 정의된 데이터를 반환하는 KanchuRepository의 mock 구현체입니다.
class MockKanjiQuizRepository: KanchuQuizRepository {
    func fetchProblems(kanjiList: [Kanji], problemType: ProblemType, count: Int) async throws -> [KanchuProblem] {
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
