//
//  QuizCountPicker.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/10/24.
//

import SwiftUI

struct QuizCountPicker: View {
    
    @EnvironmentObject private var container: DIContainer
    
    @State private var quizCount: Int = 5
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Picker("quizCount", selection: $quizCount) {
                    ForEach(1..<101) { index in
                        Text("\(index)").tag(index)
                    }
                    
                    Text("All").tag(-1)
                }
                .pretendardMedium(size: 18)
                .pickerStyle(.wheel)
                .background(Color("tertiary"))
                .clipShape(.rect(cornerRadius: 15))
                .padding()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
    
        }
        .safeAreaInset(edge: .top) {
            VStack { }
                .frame(maxWidth: .infinity)
                .background(Color("primary"))
        }
        .background(Color("background"))
        .navigationBarBackButtonHidden()
        .onAppear {
            loadState()
        }
        .onChange(of: quizCount) {
            container.learningAtQuizUseCase().setQuizCount(quizCount)
        }
    }
}

extension QuizCountPicker {
    private func loadState() {
        quizCount = container.learningAtQuizUseCase().getQuizCount()
    }
}

#Preview {
    VStack {
        Text("")
            .sheet(isPresented: .constant(true), content: {
                QuizCountPicker()
                    .presentationDetents([.medium])
            })
    }
    .environmentObject(DIContainer())
}
