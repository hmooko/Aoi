//
//  SearchKanjiUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/10/24.
//

import Foundation

protocol SearchKanjiUseCase {
    func execute(_ requestText: String) async throws -> [Kanji]
}

final class SearchKanjiService: SearchKanjiUseCase {
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository) {
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func execute(_ requestText: String) async throws -> [Kanji] {
        let commonlyUsedKanji = try await commonlyUsedKanjiRepository.fetchCommonlyUsedKanji()
        return commonlyUsedKanji.getByText(requestText)
    }
}

// MARK: - Mock Service for Testing/Preview
final class MockSearchKanjiService: SearchKanjiUseCase {
    private let kanjiList: [Kanji]
    
    init(kanjiList: [Kanji] = Kanji.sampleKanjiList) {
        self.kanjiList = kanjiList
    }
    
    func execute(_ requestText: String) async throws -> [Kanji] {
        guard !requestText.isEmpty else { return [] }
        return kanjiList.filter { $0.kanji.contains(requestText) || $0.korean.contains(requestText) || $0.meaning.contains(requestText) }
    }
}
