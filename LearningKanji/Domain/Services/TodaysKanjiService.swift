//
//  TodaysKanjiUseCases.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/1/24.
//

import Foundation

final class TodaysKanjiService: TodaysKanjiUseCase {
    
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository, userDefaultsRepository: UserDefaultsRepository) {
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func fetchTodaysKanjiList(_ completion: @escaping (Result<[Kanji], Error>) -> Void) {
        commonlyUsedKanjiRepository.fetchCommonlyUsedKanji { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let commonlyUsedKanji):
                if self.getTodaysKanjiGrade().count == 0 {
                    self.setTodaysKanjiGrade([.first])
                }
                let kanjiList = commonlyUsedKanji.getByGrade(grade: self.userDefaultsRepository.getTodaysKanjiGrade())
                let todaysKanjiList = self.todaysKanji(kanjiList: kanjiList, length: self.userDefaultsRepository.getTodaysKanjiCount())
                completion(.success(todaysKanjiList))
            }
        }
    }
    
    func getTodaysKanjiCount() -> Int {
        userDefaultsRepository.getTodaysKanjiCount()
    }
    
    func setTodaysKanjiCount(_ newValue: Int) {
        userDefaultsRepository.setTodaysKanjiCount(newValue)
    }
    
    func getTodaysKanjiGrade() -> Set<Grade> {
        Set(userDefaultsRepository.getTodaysKanjiGrade())
    }
    
    func setTodaysKanjiGrade(_ newValue: Set<Grade>) {
        userDefaultsRepository.setTodaysKanjiGrade(Array(newValue))
    }
}

extension TodaysKanjiService {
    private func todaysKanji(kanjiList: [Kanji], length: Int) -> [Kanji] {
        var result: [Kanji] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: Date())
        for i in 0..<length {
            let seed = Int("\(dateString)\(i)") ?? 0
            srand48(seed)
            
            var kanji: Kanji
            repeat {
                kanji = kanjiList[Int(drand48() * Double(kanjiList.count))]
            } while result.contains { $0 == kanji }
            
            result.append(kanji)
        }
        return result
    }
}
