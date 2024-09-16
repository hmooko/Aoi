//
//  DefaultUserDefaultsRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/5/24.
//

import Foundation

final class UserDefaultsKeys {
    static let TODAYS_KANJI_COUNT = "todaysKanjiCount"
    static let QUIZ_COUNT = "quizCount"
    static let TODATS_KANJI_GRADE = "todaysKanjiGrade"
}

final class DefaultUserDefaultsRepository: UserDefaultsRepository {
    func getTodaysKanjiCount() -> Int {
        if UserDefaults.standard.integer(forKey: UserDefaultsKeys.TODAYS_KANJI_COUNT) == 0 {
            UserDefaults.standard.set(3, forKey: UserDefaultsKeys.TODAYS_KANJI_COUNT)
            return 3
        }
        
        return UserDefaults.standard.integer(forKey: UserDefaultsKeys.TODAYS_KANJI_COUNT)
    }
    
    func setTodaysKanjiCount(_ newValue: Int) {
        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.TODAYS_KANJI_COUNT)
    }
    
    func getQuizCount() -> Int {
        if UserDefaults.standard.integer(forKey: UserDefaultsKeys.QUIZ_COUNT) == 0 {
            UserDefaults.standard.set(5, forKey: UserDefaultsKeys.QUIZ_COUNT)
            return 5
        }
        
        return UserDefaults.standard.integer(forKey: UserDefaultsKeys.QUIZ_COUNT)
    }
    
    func setQuizCount(_ newValue: Int) {
        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.QUIZ_COUNT)
    }
    
    func getTodaysKanjiGrade() -> [Grade] {
        guard let gradeString = UserDefaults.standard.array(forKey: UserDefaultsKeys.TODATS_KANJI_GRADE) else {
            UserDefaults.standard.set([Grade.first.rawValue], forKey: UserDefaultsKeys.TODATS_KANJI_GRADE)
            return [Grade.first]
        }
        
        let grade: [Grade] = (gradeString as! [String]).map {
            Grade(rawValue: $0)!
        }
        
        return grade
    }
    
    func setTodaysKanjiGrade(_ newValue: [Grade]) {
        let grade = newValue.map { $0.rawValue }
        UserDefaults.standard.set(grade, forKey: UserDefaultsKeys.TODATS_KANJI_GRADE)
    }
}
