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
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 1, trailing: 0))
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
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
        }
    }
}

#Preview {
    FlipableKanjiRow(kanji: Kanji.sampleKanji)
        .environmentObject(CoveredKanjiList())
}
