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
                    .animation(.linear, value: viewModel.currentProblemIndex)
                
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
                problemSentenceView(sentence: problem.sentence, target: problem.targetWord)
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
        // We'll ignore the 'target' argument since you want to highlight by parenthesis, not targetWord
        var texts: [Text] = []
        var current = ""
        var isInside = false
        for char in sentence {
            if char == "(" {
                if !current.isEmpty {
                    texts.append(Text(current))
                    current = ""
                }
                isInside = true
            } else if char == ")" {
                if !current.isEmpty {
                    texts.append(Text(current).foregroundColor(.blue))
                    current = ""
                }
                isInside = false
            } else {
                current.append(char)
            }
        }
        if !current.isEmpty {
            if isInside {
                texts.append(Text(current).foregroundColor(.blue))
            } else {
                texts.append(Text(current))
            }
        }
        // Combine all Texts
        return texts.reduce(Text(""), +)
    }
    
    private func buttonTint(for choice: String) -> Color {
        guard viewModel.isAnswered else { return .black }
        
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
    let container = DIContainer.preview
    let viewModel: KanchuQuizView.ViewModel = .init(container: container)
    viewModel.quizSettings.count = 5
    viewModel.quizSettings.target = .elementary(grade: .first)
    viewModel.quizSettings.problemType = .findReading
    viewModel.startQuiz()
    
    return KanchuQuizInProgressView()
        .environmentObject(viewModel)
}
