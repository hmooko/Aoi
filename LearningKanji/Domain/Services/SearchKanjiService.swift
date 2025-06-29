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
