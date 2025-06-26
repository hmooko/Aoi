//
//  LearningAtQuizView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/29/24.
//

import SwiftUI

struct LearningAtQuizView: View {
    @StateObject var viewModel: LearningAtQuizViewViewModel
    
    var body: some View {
        switch viewModel.isSubmit {
        case false:
            KanjiQuizListView(quizList: viewModel.quizList, isSubmit: $viewModel.isSubmit)
        case true:
            KanjiQuizResultView(viewModel.quizList)
        }
    }
}

#Preview {
    LearningAtQuizView(viewModel: LearningAtQuizViewViewModel(DIContainer(), quizList: Kanji.sampleKanjiList))
}
