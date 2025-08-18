//
//  KanchuQuizView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import SwiftUI

struct KanchuQuizView: View {
    
    private let project: KanchuProject?
    @StateObject private var viewModel: ViewModel
    
    /// Kanchu를 통해 문제를 생성하고 풀 수 있는 뷰입니다.
    init(container: DIContainer) {
        _viewModel = StateObject(wrappedValue: ViewModel(container: container))
        project = nil
    }
    
    /// 프로젝트의 문제들을 푸는 뷰로 바로 넘어갑니다.
    init(project: KanchuProject, container: DIContainer) {
        _viewModel = StateObject(wrappedValue: ViewModel(container: container))
        self.project = project
    }
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .settings:
                QuizSettingsView()
                    .environmentObject(viewModel)
            case .loading:
                KanchuLoadingView(text: "로딩 중...")
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
        .onAppear {
            if let project = project, viewModel.viewState == .settings {
                viewModel.startQuiz(with: project)
            }
        }
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
    KanchuQuizView(container: DIContainer.preview)
}
