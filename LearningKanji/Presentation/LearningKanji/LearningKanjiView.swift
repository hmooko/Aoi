//
//  LearningKanjiView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

protocol LearningKanji {
    var kanjiList: [Kanji] { get }
    var coveredSoundAndMeaning: Bool { get }
    var coveredKanjiList: CoveredKanjiList { get }
}

struct LearningKanjiView: View {
    @State private var learningMode: LearningMode = .list
    @State private var isCovered = false
    @State private var kanjiList: [Kanji]
    @StateObject private var coveredKanjiList = CoveredKanjiList()
    
    init(kanjiList: [Kanji]) {
        self._kanjiList = State(initialValue: kanjiList)
    }
    
    var body: some View {
        VStack {
            switch learningMode {
            case .list:
                KanjiListView(
                    kanjiList: $kanjiList,
                    coveredSoundAndMeaning: $isCovered
                )
            case .card:
                KanjiCardListView(
                    kanjiList: $kanjiList,
                    coveredSoundAndMeaning: $isCovered
                )
            }
        }
        .environmentObject(coveredKanjiList)
        .toolbar {
            Picker("select viewMode", selection: $learningMode) {
                Image(systemName: "list.bullet").tag(LearningMode.list)
                Image(systemName: "list.bullet.rectangle.portrait").tag(LearningMode.card)
            }.pickerStyle(.segmented)
            
            Menu {
                Button {
                    withAnimation {
                        isCovered.toggle()
                    }
                } label: {
                    if isCovered == true {
                        Image(systemName: "checkmark")
                    }
                    Text("한자만 보이기")
                }
                
                Button("카드 섞기") {
                    withAnimation {
                        print(kanjiList.map {$0.korean})
                        print(kanjiList.shuffled().map {$0.korean})
                        kanjiList = kanjiList.shuffled()
                        print(kanjiList.map {$0.korean})
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}

#Preview {
    LearningKanjiView(kanjiList: Kanji.sampleKanjiList)
}
