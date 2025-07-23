//
//  DefaultKanchuRepositoryIntegrationTests.swift
//  LearningKanjiTests
//
//  Created by koohyunmo on 7/13/25.
//

import XCTest
@testable import LearningKanji

/// 이 테스트는 실제 Gemini API와 통신하여 응답을 확인하는 통합 테스트입니다.
/// API 키가 필요하며, 네트워크 상태에 따라 실행 시간이 길어지거나 실패할 수 있습니다.
final class DefaultKanchuRepositoryIntegrationTests: XCTestCase {

    var repository: DefaultKanchuQuizRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = try? DefaultKanchuQuizRepository()
    }

    override func tearDownWithError() throws {
        repository = nil
        try super.tearDownWithError()
    }

    func testFetchProblems_WithRealNetworkCall_ShouldReturnValidProblems() async throws {
        // Given
        guard repository != nil else {
            throw XCTSkip("Gemini API Key가 설정되지 않아 통합 테스트를 건너뜁니다.")
        }
        
        // 실제 API 요청에 사용할 한자 목록
        let kanjiList = [
            Kanji(id: 1, kanji: "学", grade: "", sound: "", meaning: "", korean: ""),
            Kanji(id: 2, kanji: "生", grade: "", sound: "", meaning: "", korean: ""),
            Kanji(id: 3, kanji: "会", grade: "", sound: "", meaning: "", korean: ""),
            Kanji(id: 4, kanji: "社", grade: "", sound: "", meaning: "", korean: ""),
            Kanji(id: 5, kanji: "日", grade: "", sound: "", meaning: "", korean: ""),
            Kanji(id: 6, kanji: "本", grade: "", sound: "", meaning: "", korean: ""),
            Kanji(id: 7, kanji: "語", grade: "", sound: "", meaning: "", korean: ""),
            Kanji(id: 8, kanji: "人", grade: "", sound: "", meaning: "", korean: "")
        ]
        let problemType: ProblemType = .findReading
        let count = 5

        // When
        let problems = try await repository.fetchProblems(kanjiList: kanjiList, problemType: problemType, count: count)

        // Then
        XCTAssertEqual(problems.count, count, "요청한 개수(\(count)개)만큼 문제가 생성되어야 합니다.")
        print("\n✅ 요청한 개수(\(count)개)만큼 문제를 성공적으로 받아왔습니다.")

        for (index, problem) in problems.enumerated() {
            XCTAssertFalse(problem.sentence.isEmpty, "문제 \(index + 1)의 문장이 비어있으면 안됩니다.")
            XCTAssertFalse(problem.targetKanji.isEmpty, "문제 \(index + 1)의 핵심 단어가 비어있으면 안됩니다.")
            XCTAssertEqual(problem.options.count, 4, "문제 \(index + 1)의 보기는 4개여야 합니다.")
            XCTAssertTrue(problem.options.contains(problem.answer), "문제 \(index + 1)의 보기 목록에 정답이 포함되어야 합니다.")
            XCTAssertEqual(problem.type, problemType, "문제 \(index + 1)의 유형이 일치해야 합니다.")
            
            print("--- 문제 \(index + 1) 검증 완료 ---")
            print("문장: \(problem.sentence)")
            print("핵심 단어: \(problem.targetWord)")
            print("핵심 한자: \(problem.targetKanji)")
            print("보기: \(problem.options)")
            print("정답: \(problem.answer)")
            print("--------------------------\n")
        }
    }
}

