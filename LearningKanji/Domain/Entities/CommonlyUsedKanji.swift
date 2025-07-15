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
            result += kanjiList.filter { $0.grade == grade.rawValue }
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
    private let kanjiList: [Kanji]
    
    enum MiddleSchoolKanjiListError: Error {
        case invalidData(String)
    }
    
    init (kanjiList: [Kanji]) throws {
        if kanjiList.count != 1110 {
            throw MiddleSchoolKanjiListError.invalidData("Invalid data count")
        }
        
        if kanjiList.contains(where: { $0.grade != Grade.middle.rawValue}) {
            throw MiddleSchoolKanjiListError.invalidData("Invalid grade data")
        }
    }
}

struct ElementarySchoolKanjiList {
    private let kanjiList: [Kanji]
    private let gradeInfo: GradeInfo
    
    enum GradeInfo {
        case first, second, third, fourth, fifth, sixth, all
        
        func gradeCount() -> Int {
            switch self {
            case .first: return 80
            case .second: return 160
            case .third: return 200
            case .fourth: return 202
            case .fifth: return 193
            case .sixth: return 191
            case .all: return 1026
            }
        }
        
        func description() -> String {
            switch self {
            case .first: return "초등학교1학년"
            case .second: return "초등학교2학년"
            case .third: return "초등학교3학년"
            case .fourth: return "초등학교4학년"
            case .fifth: return "초등학교5학년"
            case .sixth: return "초등학교6학년"
            case .all: return "all"
            }
        }
    }
    
    enum ElementarySchoolKanjiListError: Error {
        case invalidData(String)
    }
    
    init (kanjiList: [Kanji]) throws {
        if kanjiList.count != gradeInfo.gradeCount() {
            throw ElementarySchoolKanjiListError.invalidData("Invalid data count")
        }
        
        if kanjiList.contains(where: { $0.grade != gradeInfo.description()}) {
            throw ElementarySchoolKanjiListError.invalidData("Invalid grade data")
        }
    }
}
