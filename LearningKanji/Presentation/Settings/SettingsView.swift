//
//  SettingsView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI
import Combine
import FirebaseAuth

enum SettingPicker: Identifiable {
    var id: Self {
        return self
    }
    case quizCount, todaysKanjiCount, todaysKanjiGrade
}

struct SettingsView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var container: DIContainer
    
    @State private var isLoading = false
    
    @State var quizCount: Int = 5
    @State var todaysKanjiCount: Int = 3
    
    @State var pickerSheet: SettingPicker?
    
    var body: some View {
        ZStack {
            ScrollView {
                
                settingDivider(text: "오늘의 퀴즈") {
                    todaysKanjiCountPicker
                    Divider()
                    todaysKanjiGradePicker
                }
                
                settingDivider(text: "퀴즈") {
                    quizCountPicker
                    Divider()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("설정")
                        .pretendardMedium(size: 18)
                        .foregroundStyle(.white)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top) {
                VStack { }
                    .frame(maxWidth: .infinity)
                    .background(Color("primary"))
            }
            .background(Color("background"))
            .navigationBarBackButtonHidden()
            .onAppear {
                loadSettings()
            }
            .sheet(item: $pickerSheet) { picker in
                switch picker {
                case .quizCount:
                    QuizCountPicker()
                        .presentationDetents([.medium])
                case .todaysKanjiCount:
                    TodaysKanjiCountPicker()
                        .presentationDetents([.medium])
                case .todaysKanjiGrade:
                    TodaysKanjiGradePicker()
                        .presentationDetents([.large, .medium])
                }
            }
            .onChange(of: pickerSheet) {
                loadSettings()
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }

    @ViewBuilder
    private func settingDivider(
        text: String, @ViewBuilder _ content: @escaping () -> some View
    ) -> some View {
        HStack {
            Text(text)
                .pretendardMedium(size: 16)
                .foregroundStyle(.gray)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("tertiary"))
        
        content()
    }
}

extension SettingsView {
    func loadSettings() {
        
        quizCount = container.learningAtQuizUseCase().getQuizCount()
        todaysKanjiCount = container.todaysKanjiUseCase().getTodaysKanjiCount()
        
        isLoading = false
    }
}

#Preview {
    SettingsView()
        .environmentObject(Router())
        .environmentObject(DIContainer())
}
