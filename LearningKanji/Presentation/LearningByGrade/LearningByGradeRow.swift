//
//  LearningByGradeRow.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/28/24.
//

import SwiftUI

struct LearningByGradeRow: View {
    @EnvironmentObject private var container: DIContainer
    let text: String
    let grade: Grade
    @StateObject var viewModel: LearningByGradeRowViewModel
    
    init(_ container: DIContainer, text: String, grade: Grade) {
        self.text = text
        self.grade = grade
        self._viewModel = StateObject(wrappedValue: LearningByGradeRowViewModel(container, grade: grade))
    }
    
    var body: some View {
        HStack {
            Text(text)
            
            Spacer()
            
            NavigationLink("quiz", value: AppScene.quizScene(viewModel.kanjiList))
            
            Divider().padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            NavigationLink("list", value: AppScene.learningScene(viewModel.kanjiList))
        }
        .font(.title3)
        .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
    }
}

final class LearningByGradeRowViewModel: ObservableObject {
    private let container: DIContainer
    private let learningByGradeUseCase: LearningByGradeUseCase
    @Published var kanjiList: [Kanji] = []
    
    init(_ container: DIContainer, grade: Grade) {
        self.container = container
        self.learningByGradeUseCase = container.makeLearningByGradeUseCase()
        
        self.learningByGradeUseCase.fetchKanjiListByGrade(grade: grade) { result in
            switch result {
            case .success(let kanjiList):
                self.kanjiList = kanjiList
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    LearningByGradeRow(DIContainer(), text: "first", grade: Grade.first)
}
