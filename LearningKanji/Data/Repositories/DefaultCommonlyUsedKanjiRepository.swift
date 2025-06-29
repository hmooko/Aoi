//
//  DefaultCommonlyUsedKanjiRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 6/28/25.
//

import Foundation

final class DefaultCommonlyUsedKanjiRepository {
    private let commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage
    
    init(commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage) {
        self.commonlyUsedKanjiStorage = commonlyUsedKanjiStorage
    }
}

extension DefaultCommonlyUsedKanjiRepository: CommonlyUsedKanjiRepository {
    
    func fetchCommonlyUsedKanji() async throws -> CommonlyUsedKanji {
        do {
            let kanjiList = try await commonlyUsedKanjiStorage.load()
            return CommonlyUsedKanji(kanjiList: kanjiList)
        } catch {
            throw error
        }
    }
    
}
