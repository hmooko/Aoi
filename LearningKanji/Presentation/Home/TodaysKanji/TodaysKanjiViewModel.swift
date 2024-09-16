//
//  TodaysKanjiViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation

extension TodaysKanjiView {
    class ViewModel: ObservableObject {
        @Published var todaysKanjiList: [Kanji] = []
        @Published var selection = 0
        
        private let container: DIContainer
        
        init(container: DIContainer) {
            self.container = container
            
            fetchTodaysKanjiList()
        }
        
        func fetchTodaysKanjiList() {
            container.todaysKanjiUseCase().fetchTodaysKanjiList { result in
                switch result {
                case .failure(_):
                    self.todaysKanjiList = []
                case .success(let kanjiList):
                    self.todaysKanjiList = kanjiList
                }
            }
        }
    }
}
