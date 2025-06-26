//
//  DefaultCommonlyUsedKanjiRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/1/24.
//

import Foundation

enum CommonlyUsedKanjiRepositoryError: Error {
    case notLoadCommonlyUsedKanji
}

final class DefaultCommonlyUsedKanjiRepository {
    private let commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage
    
    init(commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage) {
        self.commonlyUsedKanjiStorage = commonlyUsedKanjiStorage
    }
}

extension DefaultCommonlyUsedKanjiRepository: CommonlyUsedKanjiRepository {
    
    func fetchCommonlyUsedKanji(completion: @escaping (Result<CommonlyUsedKanji, Error>) -> Void) {
        guard let kanjiList = commonlyUsedKanjiStorage.kanjiList else {
            completion(.failure(CommonlyUsedKanjiRepositoryError.notLoadCommonlyUsedKanji))
            return
        }
        
        let commonlyUsedKanji = CommonlyUsedKanji(kanjiList: kanjiList)
        completion(.success(commonlyUsedKanji))
    }
    
}
