
//
//  GetKanchuProblemsServiceTests.swift
//  LearningKanjiTests
//
//  Created by koohyunmo on 7/13/25.
//

import XCTest
@testable import LearningKanji

final class GetKanchuProblemsServiceIntegrationTests: XCTestCase {

    var kanchuRepository: KanchuRepository!
    var bookmarksRepository: BookmarksRepository!
    var commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository!
    var sut: GetKanchuProblemsUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let commonlyUsedKanjiStorage = CommonlyUsedKanjiStorage()
        kanchuRepository = try DefaultKanchuRepository()
        bookmarksRepository = DefaultBookmarksRepository(commonlyUsedKanjiStorage: commonlyUsedKanjiStorage)
        commonlyUsedKanjiRepository = DefaultCommonlyUsedKanjiRepository(commonlyUsedKanjiStorage: commonlyUsedKanjiStorage)
        
        // 4. 테스트 대상 서비스 초기화
        sut = DefaultGetKanchuProblemsService(
            kanchuRepository: kanchuRepository,
            bookmarksRepository: bookmarksRepository,
            commonlyUsedKanjiRepository: commonlyUsedKanjiRepository
        )
    }

    override func tearDownWithError() throws {
        kanchuRepository = nil
        bookmarksRepository = nil
        commonlyUsedKanjiRepository = nil
        sut = nil
        try super.tearDownWithError()
    }

    /// 초등학생용 한자(1학년)로 퀴즈 생성을 요청했을 때, 정상적으로 문제를 받아오는지 테스트
    func testFetchProblemsForElementarySchoolGrade() async throws {
        // Given
        let target = QuizTarget.elementary(grade: .first)
        let problemType = ProblemType.findReading
        let count = 10

        // When
        let problems = try await sut.execute(target: target, problemType: problemType, count: count)

        // Then
        XCTAssertEqual(problems.count, count, "요청한 개수만큼 문제가 생성되어야 합니다.")
        XCTAssertTrue(problems.allSatisfy { $0.type == problemType }, "모든 문제의 타입이 요청한 타입과 같아야 합니다.")
        
        // TODO: 생성된 문제의 핵심 단어가 북마크에 포함된 한자인지 확인
        for (index, problem) in problems.enumerated() {
            
            print("--- 문제 \(index + 1) 검증 완료 ---")
            print("문장: \(problem.sentence)")
            print("핵심 단어: \(problem.targetKanji)")
            print("보기: \(problem.options)")
            print("정답: \(problem.answer)")
            print("--------------------------\n")
        }
    }

    /// 북마크에 저장된 한자로 퀴즈 생성을 요청했을 때, 정상적으로 문제를 받아오는지 테스트
    func testFetchProblemsForBookmarks() async throws {
        // Given
        try await bookmarksRepository.createBookmarks(title: "테스트 북마크")
        let bookmarks = try await bookmarksRepository.fetchBookmarks().filter({ $0.title == "테스트 북마크" }).first!
        for id in 1...15 {
            try await bookmarksRepository.bookmark(id, bookmarksId: bookmarks.id)
        }
        let target = QuizTarget.bookmark(id: bookmarks.id, name: bookmarks.title)
        let problemType = ProblemType.findKanji
        let count = 2

        // When
        let problems = try await sut.execute(target: target, problemType: problemType, count: count)

        // Then
        XCTAssertEqual(problems.count, count, "요청한 개수만큼 문제가 생성되어야 합니다.")
        
        // TODO: 생성된 문제의 핵심 단어가 북마크에 포함된 한자인지 확인
        for (index, problem) in problems.enumerated() {
            
            print("--- 문제 \(index + 1) 검증 완료 ---")
            print("문장: \(problem.sentence)")
            print("핵심 단어: \(problem.targetKanji)")
            print("보기: \(problem.options)")
            print("정답: \(problem.answer)")
            print("--------------------------\n")
        }
        
        try await bookmarksRepository.removeBookmarks(bookmarks.id)
    }

    /// 존재하지 않는 북마크 ID로 퀴즈 생성을 요청했을 때, `bookmarksNotFound` 에러가 발생하는지 테스트
    func testFetchProblemsForNonExistentBookmark() async {
        // Given
        let nonExistentId = 12345
        let target = QuizTarget.bookmark(id: nonExistentId, name: "없는 북마크")
        let problemType = ProblemType.findReading
        let count = 1

        // When & Then
        do {
            _ = try await sut.execute(target: target, problemType: problemType, count: count)
            XCTFail("존재하지 않는 북마크 ID로 요청 시 에러가 발생해야 합니다.")
        } catch let error as GetKanchuProblemsServiceError {
            switch error {
            case .bookmarksNotFound(let id):
                XCTAssertEqual(id, nonExistentId, "에러에 포함된 ID가 요청한 ID와 일치해야 합니다.")
                print("✅ 예상대로 bookmarksNotFound 에러 발생")
            case .bookmarkedKanjiLessThan10:
                XCTFail("존재하지 않는 북마크 ID로 요청 시 다른 에러가 발생해야 합니다.")
            }
        } catch {
            XCTFail("예상치 못한 에러 발생: \(error)")
        }
    }
}
