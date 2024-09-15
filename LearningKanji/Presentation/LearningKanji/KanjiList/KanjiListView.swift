//
//  KanjiListVIew.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct KanjiListView: View, LearningKanji {
    @Binding var kanjiList: [Kanji]
    @Binding var coveredSoundAndMeaning: Bool
    @EnvironmentObject var coveredKanjiList: CoveredKanjiList
    
    var body: some View {
        VStack {
            List(kanjiList) { kanji in
                ZStack {
                    FlipableKanjiRow(kanji: kanji)
                        .opacity(coveredSoundAndMeaning ? 1.0 : 0)
                    
                    KanjiRow(kanji: kanji)
                        .opacity(coveredSoundAndMeaning ? 0 : 1.0)
                }
            }
        }
    }
}

#Preview {
    KanjiListView(kanjiList: .constant([Kanji.sampleKanji, Kanji.sampleKanji, Kanji.sampleKanji]), coveredSoundAndMeaning: .constant(false))
        .environmentObject(CoveredKanjiList())
}
