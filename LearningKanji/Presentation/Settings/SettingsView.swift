//
//  SettingsView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack {
            List {
                quizCountPicker
                todaysKanjiCountPicker
            }
        }
        .background(Color(.systemGray6))
    }
    
    var quizCountPicker: some View {
        Picker("Quiz에 나올 한자", selection: self.$viewModel.quizCount) {
            ForEach((1...100).filter { $0 % 5 == 0 }, id: \.self) { index in
                Text("\(index)").tag(index)
            }
            Text("All").tag(-1)
        }
        .pickerStyle(.menu)
    }
    
    var todaysKanjiCountPicker: some View {
        Picker("오늘의 한자", selection: self.$viewModel.todaysKanjiCount) {
            ForEach(1...10, id: \.self) { index in
                Text("\(index)").tag(index)
            }
        }
        .pickerStyle(.menu)
    }
}

final class SettingsViewModel: ObservableObject {
    private var settingsUseCase: SettingsUseCase
    @Published var quizCount: Int {
        didSet { settingsUseCase.quizCount = quizCount}
    }
    @Published var todaysKanjiCount: Int {
        didSet { settingsUseCase.todaysKanjiCount = todaysKanjiCount }
    }
    
    init(container: DIContainer) {
        self.settingsUseCase = container.makeSeetingsUseCase()
        self.quizCount = settingsUseCase.quizCount
        self.todaysKanjiCount = settingsUseCase.todaysKanjiCount
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(container: DIContainer()))
}
