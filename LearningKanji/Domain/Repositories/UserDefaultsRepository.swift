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
    
    func getIsBackingUp() -> Bool
    func setIsBackingUP(_ newValue: Bool)
    func getIsLoadingBackup() -> Bool
    func setIsLoadingBackup(_ newValue: Bool)

    // MARK: - BYOK (Bring Your Own Key)
    func getKanchuAPIKey() -> String
    func setKanchuAPIKey(_ key: String)
    func deleteGeminiAPIKey()

    func getAIModel() throws -> any AIModel
    func setAIModel(_ model: any AIModel)
}
