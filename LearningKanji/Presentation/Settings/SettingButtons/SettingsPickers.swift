//
//  File.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/8/24.
//

import SwiftUI

extension SettingsView {
    private struct SettingsPicker: View {
        let text: String
        let status: String
        let actions: () -> Void
        
        init(text: String, status: String = "", actions: @escaping () -> Void) {
            self.text = text
            self.status = status
            self.actions = actions
        }
        
        var body: some View {
            HStack {
                Text(text)
                    .pretendardMedium(size: 18)
                Spacer()
                Text(status)
                    .pretendardMedium(size: 18)
                
                Button {
                    actions()
                } label: {
                    Image(systemName: "chevron.forward")
                        .foregroundStyle(Color("primary"))
                }
            }
            .pretendardMedium(size: 18)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
    }
    
    var quizCountPicker: some View {
        SettingsPicker(text: "퀴즈에 나올 한자", status: quizCount == -1 ? "All" : "\(quizCount)") {
            pickerSheetStyle = .quizCount
        }
    }
    
    var todaysKanjiCountPicker: some View {
        SettingsPicker(text: "오늘의 한자", status: "\(todaysKanjiCount)") {
            pickerSheetStyle = .todaysKanjiCount
        }
    }
    
    var todaysKanjiGradePicker: some View {
        SettingsPicker(text: "오늘의 한자에 나올 학년 설정") {
            pickerSheetStyle = .todaysKanjiGrade
        }
    }
    
    var backupPicker: some View {
        SettingsPicker(text: "백업 및 불러오기", status: "") {
            pickerSheetStyle = .backup
        }
    }
}

extension View {
    func settingsPickerSheet(style: Binding<SettingsPickerStyle?>, container: DIContainer) -> some View {
        self
            .sheet(item: style) { picker in
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
                case .backup:
                    BackupPicker(viewModel: .init(container: container))
                        .presentationDetents([.large])
                }
            }
    }
}
