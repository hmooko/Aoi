//
//  TodaysKanjiQuizService.swift
//  LearningKanji
//
//  Created by koohyunmo on 11/25/24.
//

import Foundation

protocol TodaysKanjiQuizUseCase {
    func excute(_ completiond: @escaping (Result<[KanjiQuiz], Error>) -> Void)
}

final class TodaysKanjiQuizService: TodaysKanjiQuizUseCase {
    func excute(_ completiond: @escaping (Result<[KanjiQuiz], any Error>) -> Void) {
        
    }
    
}
