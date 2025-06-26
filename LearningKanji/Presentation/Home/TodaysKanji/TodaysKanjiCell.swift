//
//  TodaysKanjiCell.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct TodaysKanjiCell: View {
    @EnvironmentObject private var container: DIContainer
    @State private var isBookmark = false
    let kanji: Kanji
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(kanji.kanji)
                        .pretendardBold(size: 55)
                        .foregroundStyle(Color("primary"))
                    Text("[ \(kanji.korean) ]")
                        .pretendardBold(size: 15)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("secondary"))
                }
                
                VStack(alignment: .leading) {
                    MeaningAndSound(kanji: kanji, size: 15)
                }
                
                Spacer()
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            ZStack {
                Text(kanji.grade)
                    .pretendardMedium(size: 15)
                    .foregroundStyle(Color("primary"))
                    .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                    .background(Color("secondary"))
                    .clipShape(.rect(cornerRadius: 8))
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        isBookmark = true
                    } label: {
                        Image("bookmark")
                    }
                }
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.white))
                .shadow(color: Color("shadow"), radius: 13.9, y: 4)
        }
        .padding().padding()
        .sheet(isPresented: $isBookmark, content: {
            BookmarkKanjiView(kanji, container: container)
        })
    }
}

#Preview {
    previewBackgrounds {
        TodaysKanjiCell(kanji: Kanji.sampleKanji)
    }
}
