//
//  KanjiCardListView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct KanjiCardListView: View, LearningKanji {
    @Binding var kanjiList: [Kanji]
    @Binding var coveredSoundAndMeaning: Bool
    @EnvironmentObject var coveredKanjiList: CoveredKanjiList
    @State var index = 0
    @State var sliderValue = 1.0
    
    var body: some View {
        GeometryReader { g in
            VStack {
                kanjiCardList(geometry: g)
                
                slider
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button {
                        withAnimation {
                            index -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                    }.disabled(index == 0)
                    
                    Button {
                        withAnimation {
                            index += 1
                        }
                    } label: {
                        Image(systemName: "chevron.forward")
                    }.disabled(index == kanjiList.count - 1)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func kanjiCardList(geometry g: GeometryProxy) -> some View {
        VStack {
            TabView(selection: $index) {
                ForEach(kanjiList.indices, id: \.self) { index in
                    ZStack {
                        FlipableKanjiCard(kanji: kanjiList[index], geometry: g)
                            .opacity(coveredSoundAndMeaning ? 1.0 : 0)
                        
                        KanjiCard(kanji: kanjiList[index], geometry: g)
                            .opacity(coveredSoundAndMeaning ? 0 : 1.0)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: index) {
                sliderValue = Double(index + 1)
            }
        }
        .background(Color(.systemGray6))
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
}
