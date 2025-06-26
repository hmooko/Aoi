//
//  TodaysKanjiGradePicker.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/8/24.
//

import SwiftUI

struct TodaysKanjiGradePicker: View {
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var container: DIContainer
    
    let elementary: [Grade] = [.first, .second, .third, .forth, .fifth, .sixth]
    let middle: [Grade] = [.middle]
    
    @State private var todaysKanjiGrade: Set<Grade> = .init()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                settingsList("초등학교", grade: elementary)
                
                settingsList("중학교", grade: middle)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            Spacer()
            Text("학년을 선택하지 않을 시 초등학교 1학년으로 설정됩니다.")
                .pretendardMedium(size: 15)
                .foregroundStyle(.gray)
        }
        .safeAreaInset(edge: .top) {
            VStack { }
                .frame(maxWidth: .infinity)
                .background(Color("primary"))
        }
        .background(Color("background"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.white)
                }
            }
            
            ToolbarItem(placement: .principal, content: {
                Text("오늘의 한자 학년")
                    .pretendardMedium(size: 18)
                    .foregroundStyle(.white)
            })
        }
        .onAppear {
            loadState()
        }
    }
    
    @ViewBuilder
    private func settingsList(_ title: String, grade: [Grade]) -> some View {
        HStack {
            Text(title)
                .pretendardMedium(size: 16)
                .foregroundStyle(.gray)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color("tertiary"))
        
        ForEach(grade, id: \.rawValue) { grade in
            Button {
                if containsGrade(grade: grade) {
                    removeGrade(grade: grade)
                } else {
                    insertGrade(grade: grade)
                }
            } label: {
                HStack {
                    Text(grade.rawValue)
                        .foregroundStyle(.black)
                    Spacer()
                    if containsGrade(grade: grade) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color("primary"))
                    }
                }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            }
            Divider()
        }
        .pretendardMedium(size: 18)
    }
}

extension TodaysKanjiGradePicker {
    func insertGrade(grade: Grade) {
        container.todaysKanjiUseCase().setTodaysKanjiGrade(container.todaysKanjiUseCase().getTodaysKanjiGrade().union([grade]))
        loadState()
    }
    
    func removeGrade(grade: Grade) {
        container.todaysKanjiUseCase().setTodaysKanjiGrade(container.todaysKanjiUseCase().getTodaysKanjiGrade().subtracting([grade]))
        loadState()
    }
    
    func containsGrade(grade: Grade) -> Bool {
        self.todaysKanjiGrade.contains(where: { $0 == grade })
    }
    
    func loadState() {
        self.todaysKanjiGrade = container.todaysKanjiUseCase().getTodaysKanjiGrade()
    }
}

#Preview {
    TodaysKanjiGradePicker()
        .environmentObject(Router())
        .environmentObject(DIContainer())
}
