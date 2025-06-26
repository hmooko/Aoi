//
//  CoveredKanjiList.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/8/24.
//

import Foundation

class CoveredKanjiList: ObservableObject {
    @Published var kanjiList: Set<Kanji> = []
    
    func contains(_ kanji: Kanji) -> Bool {
        kanjiList.contains(kanji)
    }
    
    func flip(_ kanji: Kanji) {
        if kanjiList.contains(kanji) {
            kanjiList.remove(kanji)
        } else {
            kanjiList.insert(kanji)
        }
    }
}
