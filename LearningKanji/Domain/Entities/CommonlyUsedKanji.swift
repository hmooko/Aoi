//
//  CommonlyUsedKanji.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/1/24.
//

import Foundation

struct CommonlyUsedKanji {
    let kanjiList: [Kanji]
    
    func getByText(_ text: String) -> [Kanji] {
        return kanjiList.filter { $0.meaning.contains(text) || $0.sound.contains(text) || $0.korean.contains(text) || $0.grade.contains(text) }
    }
    
    func getByGrade(grade: [Grade]) -> [Kanji] {
        var result: [Kanji] = []
        for grade in grade {
            result += kanjiList.filter { $0.grade.contains(grade.rawValue) }
        }
        return result
    }
    
    func getByRandom(length: Int) -> [Kanji] {
        if length < 1 { return [] }
        
        var result: [Kanji] = []
        
        while result.count < length {
            let kanji = kanjiList[Int.random(in: 0...2135)]
            
            if result.contains(kanji) == false {
                result.append(kanji)
            }
        }
        
        return result
    }
}

struct MiddleSchoolKanjiList {
    private(set) var kanjiList: [Kanji]
    
    enum MiddleSchoolKanjiListError: Error {
        case invalidData(String)
    }
    
    init (kanjiList: [Kanji]) throws {
        if kanjiList.count != Grade.gradeCount(.middle) {
            throw MiddleSchoolKanjiListError.invalidData("Invalid data count")
        }
        
        if kanjiList.contains(where: { $0.grade != Grade.middle.rawValue}) {
            throw MiddleSchoolKanjiListError.invalidData("Invalid grade")
        }
        
        self.kanjiList = kanjiList
    }
    
    func indexed(index: Int) -> [Kanji] {
        if index == 6 {
            return Array(kanjiList[((index - 1) * 190)...])
        } else {
            return Array(kanjiList[(index - 1) * 190..<index * 190])
        }
    }
}

struct ElementarySchoolKanjiList {
    private(set) var kanjiList: [Kanji]
    private(set) var grade: Grade
    
    enum ElementarySchoolKanjiListError: Error {
        case invalidData(String)
    }
    
    init (kanjiList: [Kanji], grade: Grade) throws {
        if kanjiList.count != Grade.gradeCount(grade) {
            throw ElementarySchoolKanjiListError.invalidData("Invalid data count")
        }
        
        if kanjiList.contains(where: { $0.grade != grade.rawValue }) {
            throw ElementarySchoolKanjiListError.invalidData("Invalid grade")
        }
        
        self.kanjiList = kanjiList
        self.grade = grade
    }
}
