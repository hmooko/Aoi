//
//  KanjiCardListView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct KanjiCardListView: View {
    @Binding var kanjiList: [Kanji]
    @Binding var coveredSoundAndMeaning: Bool
    @EnvironmentObject var coveredKanjiList: CoveredKanjiList
    @EnvironmentObject var container: DIContainer
    
    @State var index = 0
    @State var sliderValue = 1.0
    @State var isBookmark = false
    
    var body: some View {
        VStack {
            kanjiCardList()
            
            slider
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    withAnimation {
                        sliderValue -= 1
                    }
                } label: {
                    Image(systemName: "chevron.backward")
                }.disabled(index == 0)
                
                Button {
                    withAnimation {
                        sliderValue += 1
                    }
                } label: {
                    Image(systemName: "chevron.forward")
                }.disabled(index == kanjiList.count - 1)
                Spacer()
                Button {
                    isBookmark = true
                } label: {
                    Image(systemName: "bookmark")
                }
            }
        }
        .sheet(isPresented: $isBookmark, content: {
            BookmarkKanjiView(kanjiList[index], container: container)
        })
    }
    
    @ViewBuilder
    private func kanjiCardList() -> some View {
        VStack {
            TabView(selection: $index) {
                ForEach(kanjiList.indices, id: \.self) { index in
                    ZStack {
                        FlipableKanjiCard(kanji: kanjiList[index])
                            .opacity(coveredSoundAndMeaning ? 1.0 : 0)
                        
                        KanjiCard(kanji: kanjiList[index])
                            .opacity(coveredSoundAndMeaning ? 0 : 1.0)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: index) {
                sliderValue = Double(index + 1)
            }
        }
        .background(Color("background"))
    }
    
    @ViewBuilder
    private var slider: some View {
        if kanjiList.count > 1 {
            VStack {
                Slider(
                    value: $sliderValue,
                    in: 1...Double(kanjiList.count),
                    step: 1
                )
                .onChange(of: sliderValue) {
                    withAnimation {
                        index = Int(sliderValue) - 1
                        if sliderValue < 1 {
                            sliderValue = 1
                        }
                    }
                }
                
                Text("\(sliderValue, specifier: "%.0f") / \(kanjiList.count)")
            }
        }
    }
}

#Preview {
    KanjiCardListView(kanjiList: .constant(Kanji.sampleKanjiList), coveredSoundAndMeaning: .constant(false))
        .environmentObject(CoveredKanjiList())
        .environmentObject(DIContainer())
}
