//
//  MeaningAndSound.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/4/24.
//

import SwiftUI

struct MeaningAndSound: View {
    let kanji: Kanji
    let size: CGFloat
    let alignment: HorizontalAlignment
    
    init(kanji: Kanji, size: CGFloat) {
        self.kanji = kanji
        self.size = size
        self.alignment = .leading
    }
    
    init(kanji: Kanji, size: CGFloat, alignment: HorizontalAlignment) {
        self.kanji = kanji
        self.size = size
        self.alignment = alignment
    }
    
    var body: some View {
        if kanji.meaning == "無し" || kanji.sound == "無し" {
            ZStack {
                if kanji.meaning == "無し" {
                    sound
                } else {
                    meaning
                }
                
                VStack(alignment: self.alignment, spacing: 0) {
                    meaning
                    sound
                }.opacity(0)
            }
        } else {
            VStack(alignment: self.alignment, spacing: 0) {
                meaning
                sound
            }
        }
    }
    
    private var meaning: some View {
        HStack {
            Text("훈")
                .padding(7)
                .foregroundStyle(.white)
                .background {
                    Circle()
                        .fill(Color("primary"))
                }
                .pretendardMedium(size: size)
            Text(kanji.meaning)
                .pretendardMedium(size: size)
                .lineLimit(2)
        }
    }
    
    private var sound: some View {
        HStack {
            Text("음")
                .padding(7)
                .foregroundStyle(Color("primary"))
                .background {
                    Circle()
                        .fill(Color("secondary"))
                }
                .pretendardMedium(size: size)
            Text(kanji.sound)
                .pretendardMedium(size: size)
                .lineLimit(2)
        }
    }
}

#Preview {
    MeaningAndSound(kanji: Kanji.sampleKanji, size: 20)
}
