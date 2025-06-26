//
//  OpenAISentenceRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/23/25.
//

import Foundation

protocol OpenAISentenceRepository {
    func generateSentence(kanjiList: [Kanji], _ completion: @escaping (LearningSentence) -> Void)
}
