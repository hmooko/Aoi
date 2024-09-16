//
//  KanjiQuizUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation

final class LearningAtQuizService: LearningAtQuizUseCase {
    
    private let userDefaultsRepository: UserDefaultsRepository
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(userDefaultsRepository: UserDefaultsRepository, commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository) {
        self.userDefaultsRepository = userDefaultsRepository
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func fetchKanjiListAtQuiz(quizList: [Kanji], _ completion: @escaping (Result<[KanjiQuiz], Error>) -> Void) {
        let todaysKanjiCount = userDefaultsRepository.getQuizCount()
        var quizList = quizList.shuffled()
        if quizList.count > todaysKanjiCount {
            quizList = Array(quizList[..<todaysKanjiCount])
        }
        
        commonlyUsedKanjiRepository.fetchCommonlyUsedKanji { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let commonlyUsedKanji):
                var result: [KanjiQuiz] = []
                
                for answer in quizList {
                    var wrongSelections: [Kanji]
                    repeat {
                        wrongSelections = commonlyUsedKanji.getByRandom(length: 2)
                    } while wrongSelections.contains(where: { $0 == answer })
                    result.append(KanjiQuiz(answer, wrongSelections: wrongSelections))
                }
                completion(.success(result))
            }
        }
    }
    
    func getQuizCount() -> Int {
        userDefaultsRepository.getQuizCount()
    }
    
    func setQuizCount(_ newValue: Int) {
        userDefaultsRepository.setQuizCount(newValue)
    }
}
