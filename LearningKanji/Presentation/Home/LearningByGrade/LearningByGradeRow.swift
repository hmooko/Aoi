//
//  LearningByGradeRow2.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/24.
//

import SwiftUI

struct LearningByGradeRow: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var router: Router
    let grade: Grade
    let index: Int
    @StateObject var viewModel: ViewModel
    
    // 초등학교
    init(_ container: DIContainer, grade: Grade) {
        self.grade = grade
        self.index = 0
        self._viewModel = StateObject(wrappedValue: ViewModel(container, grade: grade, index: 0))
    }
    
    // 중학교
    init(_ container: DIContainer, grade: Grade, index: Int) {
        self.index = index
        self.grade = grade
        self._viewModel = StateObject(wrappedValue: ViewModel(container, grade: grade, index: index))
    }
    
    var body: some View {
        VStack {
            HStack {
                if grade == .middle {
                    Text("중학교 \(self.index)")
                } else {
                    Text(grade.rawValue.split(separator: "교")[1])
                }
            }
            .pretendardBold(size: 18)
            .foregroundStyle(Color("primary"))
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color("secondary"))
            
            Button {
                router.push(.learningScene(viewModel.kanjiList))
            } label: {
                Text("학습")
                    .pretendardBold(size: 15)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color("primary"))
                    }
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20))
            }.buttonStyle(.plain)
            
            Button {
                router.push(.quizScene(viewModel.kanjiList))
            } label: {
                Text("퀴즈")
                    .pretendardMedium(size: 15)
                    .foregroundStyle(Color("primary"))
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(Color("tertiary"))
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
            }.buttonStyle(.plain)
        }
        .frame(width: 130)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.white))
                .shadow(color: Color("shadow"), radius: 13.9, y: 4)
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 25, trailing: 10))
    }
}

extension LearningByGradeRow {
    final class ViewModel: ObservableObject {
        private let container: DIContainer
        private let learningByGradeUseCase: LearningByGradeUseCase
        @Published var kanjiList: [Kanji] = []
        
        init(_ container: DIContainer, grade: Grade, index: Int) {
            self.container = container
            self.learningByGradeUseCase = container.learningByGradeUseCase()
            
            self.learningByGradeUseCase.fetchKanjiListByGrade(grade: grade) { result in
                switch result {
                case .success(let kanjiList):
                    if grade != .middle {
                        self.kanjiList = kanjiList
                    } else {
                        if index == 6 {
                            self.kanjiList = Array(kanjiList[((index - 1) * 190)...])
                        } else {
                            self.kanjiList = Array(kanjiList[(index - 1) * 190..<index * 190])
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

#Preview {
    LearningByGradeRow(DIContainer(), grade: Grade.first)
}
