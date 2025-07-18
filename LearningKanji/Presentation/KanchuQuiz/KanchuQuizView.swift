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
        _viewModel = StateObject(wrappedValue: ViewModel(container: container))
    }
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .settings:
                QuizSettingsView()
                    .environmentObject(viewModel)
            case .loading:
                KanchuLoadingView(text: "퀴즈를 만들고 있어요...")
            case .quiz:
                KanchuQuizInProgressView()
                    .environmentObject(viewModel)
            case .results:
                KanchuQuizResultView()
                    .environmentObject(viewModel)
            }
        }
        .alert("에러", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { newValue in if !newValue { viewModel.errorMessage = nil } }
        ), actions: {
            Button("확인", role: .cancel) { viewModel.errorMessage = nil }
        }, message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        })
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
    KanchuQuizView(container: .preview)
}
