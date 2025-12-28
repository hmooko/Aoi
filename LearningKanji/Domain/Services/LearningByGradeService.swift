//
//  LearningByGradeUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/5/24.
//

import Foundation

protocol LearningByGradeUseCase {
    func fetchKanjiListByGrade(grade: Grade) async throws -> [Kanji]
}

final class LearningByGradeService: LearningByGradeUseCase {
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository) {
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func fetchKanjiListByGrade(grade: Grade) async throws -> [Kanji] {
        let commonlyUsedKanji = try await commonlyUsedKanjiRepository.fetchCommonlyUsedKanji()
        return filterKanjiListByGrade(commonlyUsedKanji.kanjiList, grade: grade)
    }
}

extension LearningByGradeService {
    private func filterKanjiListByGrade(_ kanjiList: [Kanji], grade: Grade) -> [Kanji] {
        kanjiList.filter { $0.grade.contains(grade.rawValue) }
    }
}

// MARK: - Mock Service for Testing/Preview
final class MockLearningByGradeService: LearningByGradeUseCase {
    private let sampleKanjiList: [Kanji]
    
    init(sampleKanjiList: [Kanji] = Kanji.sampleKanjiList) {
        self.sampleKanjiList = sampleKanjiList
    }
    
    func fetchKanjiListByGrade(grade: Grade) async throws -> [Kanji] {
        return sampleKanjiList.filter { $0.grade == grade.rawValue }
    }
}
