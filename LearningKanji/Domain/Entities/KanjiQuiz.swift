//
//  KanjiQuiz.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/29/24.
//

import Foundation

class KanjiQuiz: ObservableObject {
    @Published var selection: Kanji? = nil
    let selections: [Kanji]
    let answer: Kanji
    
    init(_ answer: Kanji, wrongSelections: [Kanji]) {
        self.answer = answer
        self.selections = ([answer] + wrongSelections).shuffled()
    }
    
    func select(_ selected: Kanji) {
        selection = selected
    }
    
    func isRight() -> Bool {
        guard let selection = selection else {
            return false
        }
        
        return answer.id == selection.id
    }
}
