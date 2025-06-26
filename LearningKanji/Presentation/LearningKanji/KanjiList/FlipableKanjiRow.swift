//
//  FlipableKanjiRow.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct FlipableKanjiRow: View {
    let kanji: Kanji
    @EnvironmentObject var coveredKanjiList: CoveredKanjiList
    
    var body: some View {
        ZStack {
            Text(kanji.kanji)
                .font(.system(size: 60))
                .opacity(coveredKanjiList.contains(kanji) ? 0 : 1.0)
            
            backSideContent
                .opacity(coveredKanjiList.contains(kanji) ? 1.0 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .onTapGesture {
            withAnimation {
                coveredKanjiList.flip(kanji)
            }
        }
        .rotation3DEffect(.degrees(coveredKanjiList.contains(kanji) ? 180 : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
    }
    
    @ViewBuilder
    private var frontSideContent: some View {
        HStack {
            Text(kanji.kanji)
                .font(.system(size: 60))
        }
    }
    
    @ViewBuilder
    private var backSideContent: some View {
        VStack(alignment: .leading) {
            MeaningAndSound(kanji: kanji, size: 16)
        }
    }
}

#Preview {
    previewBackgrounds {
        FlipableKanjiRow(kanji: Kanji.sampleKanji)
            .environmentObject(CoveredKanjiList())
    }
}
