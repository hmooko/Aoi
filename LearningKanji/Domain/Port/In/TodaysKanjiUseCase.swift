//
//  TodaysKanjiUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/8/24.
//

import Foundation

protocol TodaysKanjiUseCase {
    func fetchTodaysKanjiList(_ completion: @escaping (Result<[Kanji], Error>) -> Void)
    
    func getTodaysKanjiCount() -> Int
    func setTodaysKanjiCount(_ newValue: Int)
    
    func getTodaysKanjiGrade() -> Set<Grade>
    func setTodaysKanjiGrade(_ newValue: Set<Grade>)
}
