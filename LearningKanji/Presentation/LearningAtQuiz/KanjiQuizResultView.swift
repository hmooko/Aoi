//
//  KanjiQuizResultView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct KanjiQuizResultView: View {
    @EnvironmentObject private var container: DIContainer
    @State private var selectedKanji: Kanji? = nil
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
        List {
            VStack(alignment: .center, spacing: 20) {
                Text("정답률")
                    .pretendardMedium(size: 25)
                    
                Text("\(rightAnswer.count) / \(rightAnswer.count + wrongAnswer.count)")
                    .pretendardMedium(size: 80)
                
                Text("스와이프하여 틀린 한자를 북마크할 수 있습니다.")
                    .pretendardMedium(size: 15)
                    .foregroundStyle(.gray)
                    
            }
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            
            ForEach(wrongAnswer) { kanji in
                KanjiRow(kanji: kanji)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                         Button {
                             selectedKanji = kanji
                         } label: {
                             Image(systemName: "bookmark")
                         }.tint(Color("primary"))
                     }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectedKanji, content: { kanji in
            BookmarkKanjiView(kanji, container: container)
        })
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
