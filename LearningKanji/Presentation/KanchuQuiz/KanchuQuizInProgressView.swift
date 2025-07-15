//
//  KanchuQuizInProgressView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/9/25.
//

import SwiftUI

struct KanchuQuizInProgressView: View {
    @EnvironmentObject var viewModel: KanchuQuizView.ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let problem = viewModel.currentProblem {
                // 진행 바
                ProgressView(value: Double(viewModel.currentProblemIndex + 1), total: Double(viewModel.problems.count))
                    .progressViewStyle(.linear)
                
                HStack {
                    Text("문제 \(viewModel.currentProblemIndex + 1)/\(viewModel.problems.count)")
                    Spacer()
                    Text(problem.type.rawValue)
                        .font(.caption)
                        .padding(6)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                // 문제 예문
                problemSentenceView(sentence: problem.sentence, target: problem.targetword)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // 선택지
                VStack(spacing: 12) {
                    ForEach(problem.options, id: \.self) { choice in
                        Button(action: {
                            viewModel.submitAnswer(for: choice)
                        }) {
                            Text(choice)
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(buttonTint(for: choice))
                        .disabled(viewModel.isAnswered)
                    }
                }
                
                Spacer()
                
            } else {
                Text("문제를 불러오는 중입니다...")
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func problemSentenceView(sentence: String, target: String) -> some View {
        let parts = sentence.components(separatedBy: "[\(target)]")
        Text(parts.first ?? "") +
        Text(target).foregroundColor(.blue).underline() +
        Text(parts.last ?? "")
    }
    
    private func buttonTint(for choice: String) -> Color {
        guard viewModel.isAnswered else { return .primary }
        
        if choice == viewModel.currentProblem?.answer {
            return .green
        } else if choice == viewModel.selectedChoice {
            return .red
        } else {
            return .gray
        }
    }
}

#Preview {
    KanchuQuizInProgressView()
        .environmentObject(KanchuQuizView.ViewModel(container: DIContainer()))
}
