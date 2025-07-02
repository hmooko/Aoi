//
//  KanjiQuizUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation

protocol LearningAtQuizUseCase {
    func fetchKanjiListAtQuiz(quizList: [Kanji]) async throws -> [KanjiQuiz]
    
    func getQuizCount() -> Int
    func setQuizCount(_ newValue: Int)
}

final class LearningAtQuizService: LearningAtQuizUseCase {
    
    private let userDefaultsRepository: UserDefaultsRepository
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(userDefaultsRepository: UserDefaultsRepository, commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository) {
        self.userDefaultsRepository = userDefaultsRepository
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func fetchKanjiListAtQuiz(quizList: [Kanji]) async throws -> [KanjiQuiz] {
        let todaysKanjiCount = userDefaultsRepository.getQuizCount()
        var quizList = quizList.shuffled()
        if quizList.count > todaysKanjiCount && todaysKanjiCount != -1 {
            quizList = Array(quizList[..<todaysKanjiCount])
        }
        
        let commonlyUsedKanji = try await commonlyUsedKanjiRepository.fetchCommonlyUsedKanji()
        var result: [KanjiQuiz] = []
        
        for answer in quizList {
            var wrongSelections: [Kanji]
            repeat {
                wrongSelections = commonlyUsedKanji.getByRandom(length: 2)
            } while wrongSelections.contains(where: { $0 == answer })
            result.append(KanjiQuiz(answer, wrongSelections: wrongSelections))
        }
        return result
    }
    
    func getQuizCount() -> Int {
        userDefaultsRepository.getQuizCount()
    }
    
    func setQuizCount(_ newValue: Int) {
        userDefaultsRepository.setQuizCount(newValue)
    }
}
