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
                print(self.userDefaultsRepository.todaysKanjiGrade)
                let kanjiList = commonlyUsedKanji.getByGrade(grade: self.userDefaultsRepository.todaysKanjiGrade)
                let todaysKanjiList = self.todaysKanji(kanjiList: kanjiList, length: self.userDefaultsRepository.todaysKanjiCount)
                completion(.success(todaysKanjiList))
            }
        }
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
