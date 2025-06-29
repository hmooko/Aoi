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
            Task {
                do {
                    let todaysKanjiList = try await container.todaysKanjiUseCase().fetchTodaysKanjiList()
                    await MainActor.run {
                        self.todaysKanjiList = todaysKanjiList
                    }
                } catch {
                    self.todaysKanjiList = []
                    print(error)
                }
            }
        }
    }
}
