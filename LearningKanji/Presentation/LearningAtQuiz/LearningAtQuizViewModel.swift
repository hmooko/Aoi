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
        self.learningAtQuizUseCase = container.learningAtQuizUseCase()
        fetchQuizList(quizList: quizList)
    }
    
    func fetchQuizList(quizList kanjiList: [Kanji]) {
        Task {
            do {
                let quizList = try await learningAtQuizUseCase.fetchKanjiListAtQuiz(quizList: kanjiList)
                await MainActor.run {
                    self.quizList = quizList
                }
            } catch {
                print(error)
            }
        }
    }
}
