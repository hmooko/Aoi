//
//  SearchKanjiUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/10/24.
//

import Foundation

final class SearchKanjiService: SearchKanjiUseCase {
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository) {
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func execute(_ requestText: String, completion: @escaping (Result<[Kanji], Error>) -> Void) {
        commonlyUsedKanjiRepository.fetchCommonlyUsedKanji { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let commonlyUsedKanji):
                completion(.success(commonlyUsedKanji.getByText(requestText)))
            }
        }
    }
}
