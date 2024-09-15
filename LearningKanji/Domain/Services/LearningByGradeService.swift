//
//  LearningByGradeUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/5/24.
//

import Foundation

final class LearningByGradeService: LearningByGradeUseCase {
    private let commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository
    
    init(commonlyUsedKanjiRepository: CommonlyUsedKanjiRepository) {
        self.commonlyUsedKanjiRepository = commonlyUsedKanjiRepository
    }
    
    func fetchKanjiListByGrade(grade: Grade, _ completion: @escaping (Result<[Kanji], Error>) -> Void) {
        commonlyUsedKanjiRepository.fetchCommonlyUsedKanji { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let commonlyUsedKanji):
                completion(.success(self.filterKanjiListByGrade(commonlyUsedKanji.kanjiList, grade: grade)))
            }
        }
    }
}

extension LearningByGradeService {
    private func filterKanjiListByGrade(_ kanjiList: [Kanji], grade: Grade) -> [Kanji] {
        kanjiList.filter { $0.grade == grade.rawValue }
    }
}
