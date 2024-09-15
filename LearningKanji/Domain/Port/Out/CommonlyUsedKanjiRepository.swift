//
//  CommonlyUsedKanjiRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/1/24.
//

import Foundation

protocol CommonlyUsedKanjiRepository {
    func fetchCommonlyUsedKanji(completion: @escaping (Result<CommonlyUsedKanji, Error>) -> Void)
}
