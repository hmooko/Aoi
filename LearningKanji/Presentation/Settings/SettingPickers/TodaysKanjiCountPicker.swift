//
//  TodaysKanjiCountPicker.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/10/24.
//

import SwiftUI

struct TodaysKanjiCountPicker: View {
    @EnvironmentObject private var container: DIContainer
    
    @State private var todaysKanjiCount: Int = 3
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Picker("quizCount", selection: $todaysKanjiCount) {
                    ForEach(1..<10) { index in
                        Text("\(index)").tag(index)
                    }
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
        .onChange(of: todaysKanjiCount) {
            container.todaysKanjiUseCase().setTodaysKanjiCount(todaysKanjiCount)
        }
    }
}

extension TodaysKanjiCountPicker {
    private func loadState() {
        todaysKanjiCount = container.todaysKanjiUseCase().getTodaysKanjiCount()
    }
}

#Preview {
    TodaysKanjiCountPicker()
}
