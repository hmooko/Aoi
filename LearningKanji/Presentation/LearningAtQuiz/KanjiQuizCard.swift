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
                .pretendardMedium(size: 110)
            
            VStack(spacing: 20) {
                ForEach(kanjiQuiz.selections, id: \.self) { kanji in
                    Button {
                        kanjiQuiz.select(kanji)
                    } label: {
                        VStack(alignment: .leading) {
                            MeaningAndSound(kanji: kanji, size: 15)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(kanjiQuiz.selection == kanji ? Color("primary") : Color(.white))
                        .clipShape(.rect(cornerRadius: 15))
                    }
                    .buttonStyle(.plain)
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

