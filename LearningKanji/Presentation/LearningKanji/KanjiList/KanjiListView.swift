//
//  KanjiListVIew.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct KanjiListView: View {
    @State private var selectedKanji: Kanji? = nil
    @Binding var kanjiList: [Kanji]
    @Binding var coveredSoundAndMeaning: Bool
    @EnvironmentObject var coveredKanjiList: CoveredKanjiList
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var container: DIContainer
    
    var body: some View {
        VStack {
            List(kanjiList) { kanji in
                ZStack {
                    FlipableKanjiRow(kanji: kanji)
                        .opacity(coveredSoundAndMeaning ? 1.0 : 0)
                    
                    KanjiRow(kanji: kanji)
                        .opacity(coveredSoundAndMeaning ? 0 : 1.0)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        selectedKanji = kanji
                    } label: {
                        Image(systemName: "bookmark")
                    }.tint(Color("primary"))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("background"))
        }
        .sheet(item: $selectedKanji, content: { kanji in
            BookmarkKanjiView(kanji, container: container)
        })
    }
}

#Preview {
    KanjiListView(kanjiList: .constant([Kanji.sampleKanji, Kanji.sampleKanji, Kanji.sampleKanji]), coveredSoundAndMeaning: .constant(false))
        .environmentObject(CoveredKanjiList())
        .environmentObject(Router())
        .environmentObject(DIContainer())
}
