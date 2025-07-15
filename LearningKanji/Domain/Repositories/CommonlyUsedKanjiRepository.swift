//
//  CommonlyUsedKanjiRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 6/28/25.
//

import Foundation

protocol CommonlyUsedKanjiRepository {
    func fetchCommonlyUsedKanji() async throws -> CommonlyUsedKanji
    func fetchElementarySchoolKanjiList(grade: Grade) async throws -> ElementarySchoolKanjiList
    func fetchMiddleSchoolKanjiList() async throws -> MiddleSchoolKanjiList
}
