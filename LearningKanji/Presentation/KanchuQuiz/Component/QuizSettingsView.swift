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
    let problemCounts = [3, 5, 10]
    let elementaryTargets: [QuizTarget] = Grade.elementarySchoolCases().map { .elementary(grade: $0) }
    let middleSchoolTargets: [QuizTarget] = (1...6).map { .middleSchool(index: $0) }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section {
                    targetScrollView(title: "초등학교", targets: elementaryTargets)
                    targetScrollView(title: "중학교", targets: middleSchoolTargets)
                    targetScrollView(title: "나의 북마크", targets: viewModel.bookmarksTargets)
                } header: {
                    HStack {
                        Image(systemName: "books.vertical")
                        Text("학습 대상")
                    }
                } footer: {
                    VStack(alignment: .leading) {
                        AoiText("* 문제를 만들기 위해서는 북마크에 최소 10개 이상의 한자가 있어야 합니다.", size: 11)
                        AoiText("* 북마크에 한자가 많을 수록 AI는 더 다양한 문장을 만듭니다.", size: 11)
                    }
                    .foregroundStyle(.gray)
                }
                
                Section {
                    VStack {
                        ForEach(problemTypes, id: \.self) { type in
                            Button(action: {
                                viewModel.quizSettings.problemType = type
                            }) {
                                Text(type.rawValue)
                                    .pretendardLight(size: 20)
                                    .frame(maxWidth: .infinity)
                                    .padding(5)
                            }
                            .buttonStyle(SettingButton(isSelected: viewModel.quizSettings.problemType == type))
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "lightbulb")
                        Text("문제 유형")
                    }
                }
                
                Section {
                    HStack {
                        ForEach(problemCounts, id: \.self) { count in
                            Button(action: {
                                viewModel.quizSettings.count = count
                            }) {
                                Text("\(count)개")
                                    .pretendardLight(size: 20)
                                    .frame(maxWidth: .infinity)
                                    .padding(5)
                            }
                            .buttonStyle(SettingButton(isSelected: viewModel.quizSettings.count == count))
                        }
                    }
                } header: {
                    HStack {
                        Image(systemName: "star")
                        Text("문제 수")
                    }
                }
                
                Spacer()
            }
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
                        .buttonStyle(SettingButton(isSelected: viewModel.quizSettings.target == target))
                    }
                }
            }
        }
    }
    
    private struct SettingButton: ButtonStyle {
        var isSelected: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .pretendardBold(size: 18)
                .fontWeight(.regular)
                .padding(EdgeInsets(top: 8, leading: 13, bottom: 8, trailing: 13))
                .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemBackground))
                .foregroundColor(isSelected ? .primaryColor : .black)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(isSelected ? .primaryColor : Color.gray.opacity(0.4), lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

#Preview {
    QuizSettingsView()
        .environmentObject(KanchuQuizView.ViewModel(container: DIContainer()))
}
