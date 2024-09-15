//
//  UserDefaultsRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/5/24.
//

import Foundation

protocol UserDefaultsRepository {
    var todaysKanjiCount: Int { get set }
    var quizCount: Int { get set }
}
