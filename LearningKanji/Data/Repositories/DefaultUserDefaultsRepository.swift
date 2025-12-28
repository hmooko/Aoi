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
    static let IS_BACKING_UP = "isBackingUp"
    static let IS_LOADING_BACKUP = "isLoadingBackup"
    static let GEMINI_USER_API_KEY = "geminiUserApiKey"
    static let AI_MODEL = "aiModel"
}

enum UserDefaultsError: Error {
    case aiModelNotFound
    
    var description: String {
        switch self {
        case .aiModelNotFound:
            return "AI 모델을 찾을 수 없습니다."
        }
    }
}

final class DefaultUserDefaultsRepository: UserDefaultsRepository {
    func getIsBackingUp() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.IS_BACKING_UP)
    }
    
    func setIsBackingUP(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.IS_BACKING_UP)
    }
    
    func getIsLoadingBackup() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.IS_LOADING_BACKUP)
    }
    
    func setIsLoadingBackup(_ newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.IS_LOADING_BACKUP)
    }
    
    
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

    // MARK: - BYOK (Bring Your Own Key)
    func getKanchuAPIKey() -> String {
        UserDefaults.standard.string(forKey: UserDefaultsKeys.GEMINI_USER_API_KEY) ?? ""
    }

    func setKanchuAPIKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: UserDefaultsKeys.GEMINI_USER_API_KEY)
    }

    func deleteGeminiAPIKey() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.GEMINI_USER_API_KEY)
    }

    func getAIModel() throws -> any AIModel {
        guard let modelString = UserDefaults.standard.string(forKey: UserDefaultsKeys.AI_MODEL) else {
            return GeminiModel.gemini2_5Flash // Default model
        }

        // 먼저 Gemini 모델인지 확인
        switch modelString {
        case GeminiModel.gemini2_5Flash.rawValue:
            return GeminiModel.gemini2_5Flash
        case GeminiModel.gemini2_5Pro.rawValue:
            return GeminiModel.gemini2_5Pro
        default:
            break
        }
        
        // 다음으로 Gpt 모델인지 확인
        switch modelString {
        case GptModel.gpt5.rawValue:
            return GptModel.gpt5
        default:
            break
        }

        throw UserDefaultsError.aiModelNotFound
    }

    func setAIModel(_ model: any AIModel) {
        UserDefaults.standard.set(model.rawValue, forKey: UserDefaultsKeys.AI_MODEL)
    }
}
