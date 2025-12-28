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

// MARK: - Mock Service for Testing/Preview
final class MockLearningAtQuizService: LearningAtQuizUseCase {
    private var quizCount: Int
    private let mockQuiz: [KanjiQuiz]
    
    init(quizCount: Int = 10, quiz: [KanjiQuiz]? = nil) {
        self.quizCount = quizCount
        if let quiz = quiz {
            self.mockQuiz = quiz
        } else {
            let k1 = Kanji.sampleKanjiList.first ?? Kanji.sampleKanji
            let k2 = Kanji.sampleKanjiList.dropFirst().first ?? Kanji.sampleKanji
            let quiz1 = KanjiQuiz(k1, wrongSelections: [k2, k1])
            let quiz2 = KanjiQuiz(k2, wrongSelections: [k1, k2])
            self.mockQuiz = [quiz1, quiz2]
        }
    }
    
    func fetchKanjiListAtQuiz(quizList: [Kanji]) async throws -> [KanjiQuiz] {
        return Array(mockQuiz.prefix(quizCount))
    }
    
    func getQuizCount() -> Int {
        quizCount
    }
    
    func setQuizCount(_ newValue: Int) {
        quizCount = newValue
    }
}
