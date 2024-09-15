//
//  KanjiQuizCard.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/29/24.
//

import SwiftUI

struct KanjiQuizCard: View {
    @StateObject var kanjiQuiz: KanjiQuiz
    
    var body: some View {
        VStack {
            Text(kanjiQuiz.answer.kanji)
                .font(.system(size: 120))
            
            VStack(spacing: 20) {
                ForEach(kanjiQuiz.selections, id: \.self) { kanji in
                    Button {
                        kanjiQuiz.select(kanji)
                    } label: {
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
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .background(kanjiQuiz.selection == kanji ? Color.yellow : Color(.white))
                        .clipShape(.rect(cornerRadius: 15))
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                }
            }
        }
    }
}

#Preview {
    previewBackgrounds {
        KanjiQuizCard(kanjiQuiz:
                        KanjiQuiz(
                            Kanji.sampleKanjiList[0],
                            wrongSelections: [Kanji.sampleKanjiList[1], Kanji.sampleKanjiList[2]]
                        )
        )
    }
}

