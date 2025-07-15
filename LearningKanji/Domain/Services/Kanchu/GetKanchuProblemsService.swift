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
    private let kanchuRepository: KanchuRepository
    private let bookmarksRepository: BookmarksRepository
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(
        kanchuRepository: KanchuRepository,
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
