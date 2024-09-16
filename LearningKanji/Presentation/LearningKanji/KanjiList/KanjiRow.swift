//
//  KanjiRow.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct KanjiRow: View {
    let kanji: Kanji
    let isModify: Bool
    
    init(kanji: Kanji, isModify: Bool = false) {
        self.kanji = kanji
        self.isModify = isModify
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(kanji.kanji)
                    .pretendardMedium(size: 50)
                Text("[ \(kanji.korean) ]")
                    .pretendardMedium(size: 13)
                    .frame(maxWidth: 70)
                    .multilineTextAlignment(.center)
            }
            VStack {
                MeaningAndSound(kanji: kanji, size: 16)
            }
            Spacer()
            
            if isModify == false {
                Image(systemName: "chevron.left.2")
                    .foregroundStyle(Color("primary"))
            }
        }
    }
}

#Preview {
    KanjiRow(kanji: Kanji.sampleKanji)
}
