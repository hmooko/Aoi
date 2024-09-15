//
//  File.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/8/24.
//

import SwiftUI

extension SettingsView {
    var quizCountPicker: some View {
        HStack {
            Text("퀴즈에 나올 한자")
            Spacer()
            Text("\(quizCount)")
            Button {
                pickerSheet = .quizCount
            } label: {
                Image(systemName: "chevron.forward")
                    .foregroundStyle(Color("primary"))
            }
        }
        .pretendardMedium(size: 18)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
    var todaysKanjiCountPicker: some View {
        HStack {
            Text("오늘의 한자")
            Spacer()
            Text("\(todaysKanjiCount)")
            Button {
                pickerSheet = .todaysKanjiCount
            } label: {
                Image(systemName: "chevron.forward")
                    .foregroundStyle(Color("primary"))
            }
        }
        .pretendardMedium(size: 18)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
    var todaysKanjiGradePicker: some View {
        HStack {
            Text("오늘의 한자에 나올 학년 설정")
            Spacer()
            Button {
                pickerSheet = .todaysKanjiGrade
            } label: {
                Image(systemName: "chevron.forward")
                    .foregroundStyle(Color("primary"))
            }
        }
        .pretendardMedium(size: 18)
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
