//
//  KanjiCard.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct KanjiCard: View {
    let kanji: Kanji
    
    var body: some View {
        VStack {
            Text(kanji.grade)
                .pretendardMedium(size: 18)
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(Color(.systemGray5))
                .clipShape(.rect(cornerRadius: 5))
            Text(kanji.kanji)
                .pretendardMedium(size: 120)
            
            Text("[ \(kanji.korean) ]")
                .pretendardMedium(size: 24)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            MeaningAndSound(kanji: kanji, size: 18, alignment: .center)
        }
    }
}

extension View {
    func wrappedContentAsCard() -> some View {
        return self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .shadow(color: Color("shadow"), radius: 13.9, y: 4)
            }
            .padding(EdgeInsets(top: 100, leading: 30, bottom: 100, trailing: 30))
    }
}

#Preview {
    KanjiCard(kanji: Kanji.sampleKanji)
}
