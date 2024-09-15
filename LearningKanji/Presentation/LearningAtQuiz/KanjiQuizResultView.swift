//
//  KanjiQuizResultView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct KanjiQuizResultView: View {
    private let rightAnswer: [Kanji]
    private let wrongAnswer: [Kanji]
    
    init(_ quizList: [KanjiQuiz]) {
        var rightAnswer: [Kanji] = []
        var wrongAnswer: [Kanji] = []
        
        for quiz in quizList {
            if quiz.isRight() {
                rightAnswer.append(quiz.answer)
            } else {
                wrongAnswer.append(quiz.answer)
            }
        }
        
        self.rightAnswer = rightAnswer
        self.wrongAnswer = wrongAnswer
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                Text("정답률")
                    .font(.title)
                Text("\(rightAnswer.count) / \(rightAnswer.count + wrongAnswer.count)")
                    .font(.system(size: 80))
                
                ForEach(wrongAnswer) { kanji in
                    KanjiRow(kanji: kanji)
                        .padding()
                    Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                Spacer()
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct KanjiQuizResultView_Previews: PreviewProvider {
    static var previews: some View {
        let quiz1 = KanjiQuiz(Kanji.sampleKanji, wrongSelections: Array(Kanji.sampleKanjiList[..<2]))
        let quiz2 = KanjiQuiz(Kanji.sampleKanjiList[0], wrongSelections: Array(Kanji.sampleKanjiList[..<2]))
        
        quiz1.select(Kanji.sampleKanji)
        quiz2.select(Kanji.sampleKanji)
        
        return KanjiQuizResultView([quiz1, quiz2])
    }
}
