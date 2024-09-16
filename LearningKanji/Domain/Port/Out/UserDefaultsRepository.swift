//
//  UserDefaultsRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/5/24.
//

import Foundation

protocol UserDefaultsRepository {
    func getTodaysKanjiCount() -> Int
    func setTodaysKanjiCount(_ newValue: Int)
    
    func getQuizCount() -> Int
    func setQuizCount(_ newValue: Int)
    
    func getTodaysKanjiGrade() -> [Grade]
    func setTodaysKanjiGrade(_ newValue: [Grade])
}
