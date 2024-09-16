//
//  LearningAtQuizUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/8/24.
//

import Foundation

protocol LearningAtQuizUseCase {
    func fetchKanjiListAtQuiz(quizList: [Kanji], _ completion: @escaping (Result<[KanjiQuiz], Error>) -> Void)
    
    func getQuizCount() -> Int
    func setQuizCount(_ newValue: Int)
}
