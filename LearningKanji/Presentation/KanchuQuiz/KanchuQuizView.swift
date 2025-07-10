//
//  KanchuQuizView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import SwiftUI

struct KanchuQuizView: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(container: DIContainer) {
        _viewModel = StateObject(wrappedValue: ViewModel(
            getKanchuProblemsUseCase: container.makeGetKanchuProblemsUsecase(),
            calculateKanchuProblemsResultUseCase: container.makeCalculateKanchuProblemsResult()
        ))
    }
    
    var body: some View {
        // ViewModel의 viewState에 따라 적절한 화면을 보여줍니다.
//        switch viewModel.viewState {
//        case .settings:
//            QuizSettingsView()
//                .environmentObject(viewModel)
//        case .loading:
//            KanchuLoadingView(text: "퀴즈를 만들고 있어요...")
//        case .quiz:
//            KanchuQuizInProgressView()
//                .environmentObject(viewModel)
//        case .results:
//            KanchuQuizResultView()
//                .environmentObject(viewModel)
//        }
    }
}

// --- 로딩 뷰 ---
struct KanchuLoadingView: View {
    let text: String
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text(text)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    KanchuQuizView(container: DIContainer())
}
