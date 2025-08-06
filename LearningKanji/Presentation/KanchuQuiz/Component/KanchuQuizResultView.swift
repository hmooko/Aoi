//
//  KanchuQuizResultView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/9/25.
//

import SwiftUI

struct KanchuQuizResultView: View {
    @EnvironmentObject var viewModel: KanchuQuizView.ViewModel
        
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let result = viewModel.quizResult {
                    // 점수판
                    VStack {
                        Text("최종 점수")
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Text("\(Int(result.score))")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(result.score >= 80 ? .blue : .orange)
                        Text("\(result.correctAnswers) / \(result.totalProblems) 정답")
                            .font(.headline)
                    }
                    .padding(32)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    
                    // 오답 노트
                    let incorrectAnswers = result.userAnswers.filter { !$0.isCorrect }
                    if !incorrectAnswers.isEmpty {
                        VStack(alignment: .leading) {
                            Text("오답 노트").font(.title2).bold()
                            ForEach(incorrectAnswers, id: \.problem.id) { answer in
                                incorrectAnswerCell(answer)
                                Divider()
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("학습 결과")
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button(action: {
                    viewModel.startNewQuiz()
                }) {
                    AoiText("새로운 퀴즈 시작", size: 20)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .padding(10)
                }
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primaryColor)
                }
                
                Button(action: {
                    viewModel.goHome()
                }) {
                    AoiText("홈으로", size: 20)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.primaryColor)
                        .padding(10)
                }
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.tertiaryColor)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func incorrectAnswerCell(_ answer: UserAnswer) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(answer.problem.sentence.replacingOccurrences(of: "[\(answer.problem.targetWord)]", with: answer.problem.targetWord))
                .font(.body)
                .foregroundStyle(.secondary)
            HStack {
                Text(answer.submittedAnswer)
                    .strikethrough()
                    .foregroundColor(.red)
                Image(systemName: "arrow.right")
                Text(answer.problem.answer)
                    .foregroundColor(.green)
            }
            .font(.headline)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    
    return KanchuQuizResultView()
        .environmentObject(KanchuQuizView.ViewModel(container: .preview))
}
