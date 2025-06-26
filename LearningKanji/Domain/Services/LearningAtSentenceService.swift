//
//  LearningAtSentenceService.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/23/25.
//

import Foundation

protocol LearningAtSentenceUseCase {
    func generateSentence(kanjiList: [Kanji], _ completion: @escaping (LearningSentence) -> Void)
}

final class LearningAtSentenceService: LearningAtSentenceUseCase {
    private let openAISentenceRepository: OpenAISentenceRepository
    
    init(openAISentenceRepository: OpenAISentenceRepository) {
        self.openAISentenceRepository = openAISentenceRepository
    }
    
    func generateSentence(kanjiList: [Kanji], _ completion: @escaping (LearningSentence) -> Void) {
        openAISentenceRepository.generateSentence(kanjiList: kanjiList) { sentence in
            completion(sentence)
        }
    }
}
