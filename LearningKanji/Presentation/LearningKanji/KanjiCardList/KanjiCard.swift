//
//  KanjiCard.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct KanjiCard: View {
    let kanji: Kanji
    let geometry: GeometryProxy
    
    var body: some View {
        KanjiCard.wrappedContentAsCard(geometry: geometry) {
            VStack {
                Text(kanji.grade)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(Color(.systemGray5))
                    .clipShape(.rect(cornerRadius: 5))
                Text(kanji.kanji)
                    .font(.system(size: 120))
                
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
    
    static func wrappedContentAsCard(geometry: GeometryProxy, content: @escaping () -> some View) -> some View {
        return content()
            .frame(width: geometry.size.width - 50, height: geometry.size.height - 300)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 15))
            .padding(EdgeInsets(top: 130, leading: 25, bottom: 130, trailing: 25))
    }
}

#Preview {
    previewBackgrounds {
        GeometryReader { g in
            KanjiCard(kanji: Kanji.sampleKanji, geometry: g)
        }
    }
}
