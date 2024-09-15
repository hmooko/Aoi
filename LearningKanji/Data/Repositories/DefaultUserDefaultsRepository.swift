//
//  DefaultUserDefaultsRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/5/24.
//

import Foundation

final class DefaultUserDefaultsRepository: UserDefaultsRepository {
    private let TODAYS_KANJI_COUNT = "todaysKanjiCount"
    private let QUIZ_COUNT = "quizCount"
    
    var todaysKanjiCount: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: QUIZ_COUNT)
        }
        get {
            if UserDefaults.standard.integer(forKey: QUIZ_COUNT) == 0 {
                UserDefaults.standard.set(3, forKey: QUIZ_COUNT)
                return 3
            }
            
            return UserDefaults.standard.integer(forKey: QUIZ_COUNT)
        }
    }
    
    var quizCount: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: TODAYS_KANJI_COUNT)
        }
        get {
            if UserDefaults.standard.integer(forKey: TODAYS_KANJI_COUNT) == 0 {
                UserDefaults.standard.set(5, forKey: TODAYS_KANJI_COUNT)
                return 5
            }
            
            return UserDefaults.standard.integer(forKey: TODAYS_KANJI_COUNT)
        }
    }
}
