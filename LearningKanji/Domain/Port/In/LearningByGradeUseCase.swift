//
//  LearningByGradeUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/8/24.
//

import Foundation

protocol LearningByGradeUseCase {
    func fetchKanjiListByGrade(grade: Grade, _ completion: @escaping (Result<[Kanji], Error>) -> Void)
}
