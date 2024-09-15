//
//  LearningKanjiSceneDIContainer.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation
import SwiftUI

final class DIContainer: ObservableObject {
    
    // MARK: - singleton
    private let commonlyUsedKanjiStorage = CommonlyUsedKanjiStorage()
    private let userDefaultsRepository = DefaultUserDefaultsRepository()
    private var bookmarksRepository: BookmarksRepository? = nil

    // MARK: - Use Cases
    func makeTodaysKanjiUseCase() -> TodaysKanjiUseCase {
        DefaultTodaysKanjiUseCase(
            commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository(),
            userDefaultsRepository: makeUserDefaultsRepository()
        )
    }
    
    func makeLearningByGradeUseCase() -> LearningByGradeUseCase {
        DefaultLearningByGradeUseCase(commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository())
    }
    
    func makeLearningAtQuizUseCase() -> LearningAtQuizUseCase {
        DefaultLearningAtQuizUseCase(
            userDefaultsRepository: makeUserDefaultsRepository(),
            commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository()
        )
    }
    
    func makeSeetingsUseCase() -> SettingsUseCase {
        DefaultSettingsUseCase(userDefaultsRepository: makeUserDefaultsRepository())
    }
    
    func makeBookmarksUseCase() -> BookmarksUseCase {
        DefaultBookmarksUseCase(bookmarksRepository: makeBoookmarksRepository())
    }
    
    func makeSearchKanjiUseCase() -> SearchKanjiUseCase {
        DefaultSearchKanjiUseCase(commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository())
    }
    
    // MARK: - Repository
    private func makeCommonlyUsedKanjiRepository() -> CommonlyUsedKanjiRepository {
        DefaultCommonlyUsedKanjiRepository(commonlyUsedKanjiStorage: commonlyUsedKanjiStorage)
    }
    
    private func makeUserDefaultsRepository() -> UserDefaultsRepository {
        userDefaultsRepository
    }
    
    private func makeBoookmarksRepository() -> BookmarksRepository {
        guard let bookmarksRepository = self.bookmarksRepository else {
            self.bookmarksRepository = DefaultBookmarksRepository(commonlyUsedKanjiStorage: commonlyUsedKanjiStorage)
            return self.bookmarksRepository!
        }
        
        return bookmarksRepository
    }
}
