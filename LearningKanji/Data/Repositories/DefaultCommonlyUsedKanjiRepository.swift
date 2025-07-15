//
//  DefaultCommonlyUsedKanjiRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 6/28/25.
//

import Foundation

final class DefaultCommonlyUsedKanjiRepository {
    private let commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage
    
    init(commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage) {
        self.commonlyUsedKanjiStorage = commonlyUsedKanjiStorage
    }
}

extension DefaultCommonlyUsedKanjiRepository: CommonlyUsedKanjiRepository {
    
    func fetchCommonlyUsedKanji() async throws -> CommonlyUsedKanji {
        do {
            let kanjiList = try await commonlyUsedKanjiStorage.load()
            return CommonlyUsedKanji(kanjiList: kanjiList)
        } catch {
            throw error
        }
    }
    
    func fetchElementarySchoolKanjiList(grade: ElementarySchoolKanjiList.GradeInfo) async throws -> ElementarySchoolKanjiList {
        let kanjiList = try await commonlyUsedKanjiStorage.load()
        
        if grade == .all {
            return try ElementarySchoolKanjiList(kanjiList: kanjiList.filter({$0.grade.contains("초등학교")}))
        } else {
            return try ElementarySchoolKanjiList(kanjiList: kanjiList.filter({$0.grade == grade.description()}))
        }
    }
    
    func fetchMiddleSchoolKanjiList() async throws -> MiddleSchoolKanjiList {
        let kanjiList = try await commonlyUsedKanjiStorage.load()
        return try MiddleSchoolKanjiList(kanjiList: kanjiList.filter({$0.grade == Grade.middle.rawValue}))
    }
}
