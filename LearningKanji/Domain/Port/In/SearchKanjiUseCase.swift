//
//  SearchKanjiUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/8/24.
//

import Foundation

protocol SearchKanjiUseCase {
    func execute(_ requestText: String, completion: @escaping (Result<[Kanji], Error>) -> Void)
}
