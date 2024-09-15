//
//  TodaysKanjiViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation

final class TodaysKanjiViewModel: ObservableObject {
    private let container: DIContainer
    private let todaysKanjiUseCase: TodaysKanjiUseCase
    @Published var todaysKanjiList: [Kanji] = []
    
    init(container: DIContainer) {
        self.container = container
        self.todaysKanjiUseCase = container.makeTodaysKanjiUseCase()
        
        self.todaysKanjiUseCase.fetchTodaysKanjiList { result in
            switch result {
            case .failure(_):
                self.todaysKanjiList = []
            case .success(let kanjiList):
                self.todaysKanjiList = kanjiList
            }
        }
    }
}
