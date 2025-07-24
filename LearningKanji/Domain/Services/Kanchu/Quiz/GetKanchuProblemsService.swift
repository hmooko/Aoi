//
//  GetKanchuProblemsService.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

enum GetKanchuProblemsServiceError: Error, LocalizedError {
    case bookmarksNotFound(Int)
    case bookmarkedKanjiLessThan10
    
    var errorDescription: String? {
        switch self {
        case .bookmarksNotFound(let id):
            return "ID가 \(id)인 북마크를 찾을 수 없습니다."
        case .bookmarkedKanjiLessThan10:
            return "북마크에 저장된 한자가 너무 적습니다."
        }
    }
}

// --- 퀴즈 문제 목록 가져오기 유즈케이스 ---
protocol GetKanchuProblemsUseCase {
    /// 퀴즈를 시작하기 위해 문제 목록을 가져옵니다.
    func execute(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanchuProblem]
}

final class DefaultGetKanchuProblemsService: GetKanchuProblemsUseCase {
    private let kanchuRepository: KanchuQuizRepository
    private let bookmarksRepository: BookmarksRepository
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(
        kanchuRepository: KanchuQuizRepository,
        bookmarksRepository: BookmarksRepository,
        commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    ) {
        self.kanchuRepository = kanchuRepository
        self.bookmarksRepository = bookmarksRepository
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func execute(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanchuProblem] {
        let kanjiList: [Kanji]
        
        switch target {
        case .bookmark(let id, _):
            let bookmarks = try await bookmarksRepository.fetchBookmarks()
            guard let bookmark = bookmarks.first(where: { $0.id == id }) else {
                throw GetKanchuProblemsServiceError.bookmarksNotFound(id)
            }
            let kanjiContents = bookmark.contents
            guard kanjiContents.count >= 10 else {
                throw GetKanchuProblemsServiceError.bookmarkedKanjiLessThan10
            }
            kanjiList = kanjiContents
            
        case .elementary(let grade):
            let elementarySchoolKanjiList = try await commonlyUsedKanjiRepository.fetchElementarySchoolKanjiList(grade: grade)
            kanjiList = elementarySchoolKanjiList.kanjiList
        case .middleSchool(let index):
            let middleSchoolKanjiList = try await commonlyUsedKanjiRepository.fetchMiddleSchoolKanjiList()
            kanjiList = middleSchoolKanjiList.indexed(index: index)
        }
        
        return try await kanchuRepository.fetchProblems(kanjiList: kanjiList, problemType: problemType, count: count)
    }
}

// MARK: - Mock Service for Testing/Preview
final class MockGetKanchuProblemsService: GetKanchuProblemsUseCase {
    
    init() {
    }
    
    func execute(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanchuProblem] {
        switch problemType {
        case .findReading:
            let problems = [
                KanchuProblem(id: UUID(), type: .findReading, sentence: "友達に駅で(会います)。", targetKanji: "会", options: ["あいます", "かいます", "えいます", "あう"], answer: "あいます", targetWord: "会います"),
                KanchuProblem(id: UUID(), type: .findReading, sentence: "私は本を(読みます)。", targetKanji: "読", options: ["よみます", "とみます", "どくます", "よみ"], answer: "よみます", targetWord: "読みます"),
                KanchuProblem(id: UUID(), type: .findReading, sentence: "毎日水を(飲みます)。", targetKanji: "飲", options: ["のみます", "みずます", "のみる", "のみ"], answer: "のみます", targetWord: "飲みます"),
                KanchuProblem(id: UUID(), type: .findReading, sentence: "子供が公園で(遊びます)。", targetKanji: "遊", options: ["あそびます", "およぎます", "あそぶ", "あそび"], answer: "あそびます", targetWord: "遊びます"),
                KanchuProblem(id: UUID(), type: .findReading, sentence: "朝ご飯を(食べます)。", targetKanji: "食", options: ["たべます", "しょくます", "たべる", "たべ"], answer: "たべます", targetWord: "食べます")
            ]
            try await Task.sleep(for: .seconds(3))
            return Array(problems.prefix(count))
        case .findKanji:
            let problems = [
                KanchuProblem(id: UUID(), type: .findKanji, sentence: "きょう(はは)なを買いました。", targetKanji: "花", options: ["花", "草", "木", "米"], answer: "花", targetWord: "はな"),
                KanchuProblem(id: UUID(), type: .findKanji, sentence: "(みず)を飲みます。", targetKanji: "水", options: ["水", "火", "木", "金"], answer: "水", targetWord: "みず"),
                KanchuProblem(id: UUID(), type: .findKanji, sentence: "(ひ)を消してください。", targetKanji: "火", options: ["水", "火", "風", "土"], answer: "火", targetWord: "ひ"),
                KanchuProblem(id: UUID(), type: .findKanji, sentence: "あの(き)は高いです。", targetKanji: "木", options: ["木", "草", "花", "山"], answer: "木", targetWord: "き"),
                KanchuProblem(id: UUID(), type: .findKanji, sentence: "(かね)が必要です。", targetKanji: "金", options: ["金", "土", "水", "火"], answer: "金", targetWord: "かね")
            ]
            try await Task.sleep(for: .seconds(3))
            return Array(problems.prefix(count))
        case .fillReading:
            let problems = [
                KanchuProblem(id: UUID(), type: .fillReading, sentence: "私は本を(＿＿＿)。", targetKanji: "読", options: ["よみます", "とみます", "どくます", "よみ"], answer: "よみます", targetWord: "読みます"),
                KanchuProblem(id: UUID(), type: .fillReading, sentence: "朝ご飯を(＿＿＿)。", targetKanji: "食", options: ["たべます", "しょくます", "たべる", "たべ"], answer: "たべます", targetWord: "食べます"),
                KanchuProblem(id: UUID(), type: .fillReading, sentence: "毎日水を(＿＿＿)。", targetKanji: "飲", options: ["のみます", "みずます", "のみる", "のみ"], answer: "のみます", targetWord: "飲みます"),
                KanchuProblem(id: UUID(), type: .fillReading, sentence: "母と買い物に(＿＿＿)。", targetKanji: "行", options: ["いきます", "ゆきます", "こうきます", "いく"], answer: "いきます", targetWord: "行きます"),
                KanchuProblem(id: UUID(), type: .fillReading, sentence: "子供が公園で(＿＿＿)。", targetKanji: "遊", options: ["あそびます", "およぎます", "あそぶ", "あそび"], answer: "あそびます", targetWord: "遊びます")
            ]
            try await Task.sleep(for: .seconds(3))
            return Array(problems.prefix(count))
        }
    }
}
