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
    
    var body: some View {
        ZStack {
            Text(kanji.kanji)
                .pretendardMedium(size: 120)
                .wrappedContentAsCard()
                .opacity(coveredKanjiList.contains(kanji) ? 0 : 1.0)
            
            
            backSideContent
                .wrappedContentAsCard()
                .opacity(coveredKanjiList.contains(kanji) ? 1.0 : 0)
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
                .pretendardMedium(size: 18)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(Color(.systemGray5))
                .clipShape(.rect(cornerRadius: 5))
            
            Text(kanji.korean)
                .pretendardMedium(size: 24)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            MeaningAndSound(kanji: kanji, size: 20)
        }
    }
}

#Preview {
    FlipableKanjiCard(kanji: Kanji.sampleKanji)
        .environmentObject(CoveredKanjiList())
}
