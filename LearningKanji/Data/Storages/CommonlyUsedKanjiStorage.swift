//
//  CommonlyUsedKanjiStorage.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/2/24.
//

import Foundation

final class CommonlyUsedKanjiStorage {
    var kanjiList: [Kanji]? = nil
    
    init() {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: "japanese_kanji_2136.json", withExtension: nil)
        else {
            print("Couldn't find 'japanese_kanji_2136.json' in main bundle.")
            return
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            print("Couldn't load 'japanese_kanji_2136.json' from main bundle:\n\(error)")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            self.kanjiList = try decoder.decode([Kanji].self, from: data)
        } catch {
            print("Couldn't parse 'japanese_kanji_2136.json' as \([Kanji].self):\n\(error)")
        }
    }

}
