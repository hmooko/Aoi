//
//  KanjiQuizListView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct KanjiQuizListView: View {
    @EnvironmentObject private var router: Router
    @State private var index = 0
    @State private var sliderValue = 1.0
    let quizList: [KanjiQuiz]
    @Binding var isSubmit: Bool
    
    var body: some View {
        VStack {
            TabView(selection: $index) {
                ForEach(quizList.indices, id: \.self) { index in
                    KanjiQuizCard(kanjiQuiz: quizList[index])
                }
                
                submitView
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onChange(of: index) {
            sliderValue = Double(index + 1)
        }
        .background(Color("background"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(Color("primary"))
                }
            }
        }
        .navigationBarBackButtonHidden()
        
        slider
    }
    
    @ViewBuilder private var submitView: some View {
        VStack {
            Button {
                isSubmit = true
            } label: {
                Text("답안 제출하기")
                    .font(.title)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .background(Color(.white))
                    .clipShape(.rect(cornerRadius: 15))
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
    
    @ViewBuilder
    private var slider: some View {
        if quizList.count > 1 {
            VStack {
                Slider(
                    value: $sliderValue,
                    in: 1...Double(quizList.count),
                    step: 1
                )
                .onChange(of: sliderValue) {
                    withAnimation {
                        index = Int(sliderValue) - 1
                        if sliderValue < 1 {
                            sliderValue = 1
                        }
                    }
                }
                
                Text("\(sliderValue, specifier: "%.0f") / \(quizList.count)")
            }
        }
    }
}

#Preview {
    KanjiQuizListView(
        quizList: [
            KanjiQuiz(Kanji.sampleKanji, wrongSelections: Array(Kanji.sampleKanjiList[..<2])),
            KanjiQuiz(Kanji.sampleKanjiList[0], wrongSelections: Array(Kanji.sampleKanjiList[..<2]))
        ],
        isSubmit: .constant(false)
    )
}
