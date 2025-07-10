//
//  QuizSettingsView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import SwiftUI

struct QuizSettingsView: View {
    @EnvironmentObject var viewModel: KanchuQuizView.ViewModel
    
    // UI 구성을 위한 데이터
    let problemTypes = ProblemType.allCases
    let problemCounts = [5, 10, 20]
    let elementaryTargets: [QuizTarget] = (1...6).map { .elementary(grade: $0) }
    let middleSchoolTargets: [QuizTarget] = (1...6).map { .middleSchool(index: $0) }
    let bookmarkTargets: [QuizTarget] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Section("학습 대상") {
                targetScrollView(title: "초등학교", targets: elementaryTargets)
                targetScrollView(title: "중학교", targets: middleSchoolTargets)
                targetScrollView(title: "나의 북마크", targets: bookmarkTargets)
            }
            .pretendardBold(size: 20)
            
            Section("문제 유형") {
                Picker("문제 유형", selection: $viewModel.quizSettings.problemType) {
                    ForEach(problemTypes, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("문항 수") {
                Picker("문항 수", selection: $viewModel.quizSettings.count) {
                    ForEach(problemCounts, id: \.self) { count in
                        Text("\(count)개").tag(count)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                viewModel.startQuiz()
            }) {
                Text("퀴즈 시작")
                    .pretendardMedium(size: 21)
                    .frame(maxWidth: .infinity)
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
    
    @ViewBuilder
    private func targetScrollView(title: String, targets: [QuizTarget]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline).foregroundStyle(.secondary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(targets, id: \.self) { target in
                        Button(action: {
                            viewModel.quizSettings.target = target
                        }) {
                            Text(target.getString())
                                .pretendardLight(size: 20)
                                .padding(5)
                        }
                        .buttonStyle(.bordered)
                        .tint(viewModel.quizSettings.target == target ? .blue : .gray)
                    }
                }
            }
            .padding(.horizontal, -16)
        }
    }
    
    @ViewBuilder
    private func settingButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundColor(.blue)
        }
    }
}

#Preview {
    QuizSettingsView()
        .environmentObject(KanchuQuizView.ViewModel(getKanchuProblemsUseCase: DIContainer().makeGetKanchuProblemsUsecase(), calculateKanchuProblemsResultUseCase: DIContainer().makeCalculateKanchuProblemsResult()))
}

#Preview("settingButton") {
    
}
