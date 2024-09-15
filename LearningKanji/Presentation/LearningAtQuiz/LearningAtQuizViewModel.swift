//
//  LearningAtQuizViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import Foundation

class LearningAtQuizViewViewModel: ObservableObject {
    private let learningAtQuizUseCase: LearningAtQuizUseCase
    let container: DIContainer
    @Published var quizList: [KanjiQuiz] = []
    @Published var isSubmit = false
    
    init(_ container: DIContainer, quizList: [Kanji]) {
        self.container = container
        self.learningAtQuizUseCase = container.makeLearningAtQuizUseCase()
        fetchQuizList(quizList: quizList)
    }
    
    func fetchQuizList(quizList kanjiList: [Kanji]) {
        learningAtQuizUseCase.fetchKanjiListAtQuiz(quizList: kanjiList) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let quizList):
                self.quizList = quizList
            }
        }
    }
}
