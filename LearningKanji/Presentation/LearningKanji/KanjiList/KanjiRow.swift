//
//  KanjiRow.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct KanjiRow: View {
    let kanji: Kanji
    
    var body: some View {
        HStack {
            VStack {
                Text(kanji.kanji)
                    .font(.system(size: 60))
                Text(kanji.korean)
                    .frame(maxWidth: 70)
                    .multilineTextAlignment(.center)
            }
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
            Spacer()
        }
    }
}

#Preview {
    KanjiRow(kanji: Kanji.sampleKanji)
}
