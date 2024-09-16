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
    @EnvironmentObject private var router: Router
    
    @State private var learningMode: LearningMode = .list
    @State private var isCovered = false
    @State private var kanjiList: [Kanji]
    @StateObject private var coveredKanjiList = CoveredKanjiList()
    
    init(kanjiList: [Kanji]) {
        self._kanjiList = State(initialValue: kanjiList)
        UISegmentedControl.appearance().backgroundColor = UIColor(named: "secondary")
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
            ToolbarItem(placement: .topBarTrailing) {
                Picker("select viewMode", selection: $learningMode) {
                    Image(systemName: "list.bullet").tag(LearningMode.list)
                    Image(systemName: "list.bullet.rectangle.portrait").tag(LearningMode.card)
                }
                .pickerStyle(.segmented)
            }
            ToolbarItem(placement: .topBarTrailing) {
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
                    
                    Button("한자 섞기") {
                        withAnimation {
                            kanjiList = kanjiList.shuffled()
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(.white)
                }
            }
        }
        .aoiDefaultNavigationBar(router: router)
    }
}

#Preview {
    LearningKanjiView(kanjiList: Kanji.sampleKanjiList)
        .environmentObject(Router())
}
