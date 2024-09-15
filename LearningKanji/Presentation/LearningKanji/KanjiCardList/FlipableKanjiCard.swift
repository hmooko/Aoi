//
//  FliableKanjiCard.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct FlipableKanjiCard: View {
    @EnvironmentObject var coveredKanjiList: CoveredKanjiList
    let kanji: Kanji
    let geometry: GeometryProxy
    
    init(kanji: Kanji, geometry: GeometryProxy) {
        self.kanji = kanji
        self.geometry = geometry
    }
    
    var body: some View {
        ZStack {
            KanjiCard.wrappedContentAsCard(geometry: geometry) {
                Text(kanji.kanji)
                    .font(.system(size: 120))
            }.opacity(coveredKanjiList.contains(kanji) ? 0 : 1.0)
            
            KanjiCard.wrappedContentAsCard(geometry: geometry) {
                backSideContent
            }.opacity(coveredKanjiList.contains(kanji) ? 1.0 : 0)
            .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
        }
        .onTapGesture {
            withAnimation {
                coveredKanjiList.flip(kanji)
            }
        }
        .rotation3DEffect(.degrees(coveredKanjiList.contains(kanji) ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
    
    private var backSideContent: some View {
        VStack {
            Text(kanji.grade)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(Color(.systemGray5))
                .clipShape(.rect(cornerRadius: 5))
            
            Text(kanji.korean)
                .font(.title)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            if kanji.meaning != "無し" {
                HStack {
                    Text("훈")
                        .foregroundStyle(.white)
                        .background(Color.gray)
                        .clipShape(.rect(cornerRadius: 5))
                        .font(.title2)
                    Text(kanji.meaning)
                        .font(.title2)
                }
            }
            
            if kanji.sound != "無し" {
                HStack {
                    Text("음")
                        .foregroundStyle(.white)
                        .background(Color.black)
                        .clipShape(.rect(cornerRadius: 5))
                        .font(.title2)
                    Text(kanji.sound)
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    previewBackgrounds {
        GeometryReader { g in
            FlipableKanjiCard(kanji: Kanji.sampleKanji, geometry: g)
        }
    }
}
