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
