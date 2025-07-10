//
//  LearningKanjiSceneDIContainer.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation
import SwiftUI

final class DIContainer: ObservableObject {
    // MARK: - Services
    private let todaysKanjiService: TodaysKanjiUseCase? = nil
    private let learningByGradeService: LearningByGradeUseCase? = nil
    private let learningAtQuizService: LearningAtQuizUseCase? = nil
    private let bookmarksService: BookmarksUseCase? = nil
    private let searchKanjiService: SearchKanjiUseCase? = nil
    private let iCloudBookmarksService: ICloudBookmarksUseCase? = nil
    private let getKanchuProblemsService: GetKanchuProblemsUseCase? = nil
    private let calculateKanchuProblemsResultervice: CalculateKanchuProblemsResultUseCase? = nil
    
    // MARK: - singleton
    private let commonlyUsedKanjiStorage = CommonlyUsedKanjiStorage.shared

    // MARK: - Use Cases
    func todaysKanjiUseCase() -> TodaysKanjiUseCase {
        guard let todaysKanjiService = self.todaysKanjiService else {
            return TodaysKanjiService(
                commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository(),
                userDefaultsRepository: makeUserDefaultsRepository()
            )
        }
        
        return todaysKanjiService
    }
    
    func learningByGradeUseCase() -> LearningByGradeUseCase {
        guard let learningByGradeService = self.learningByGradeService else {
            return LearningByGradeService(commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository())
        }
        
        return learningByGradeService
    }
    
    func learningAtQuizUseCase() -> LearningAtQuizUseCase {
        guard let learningAtQuizService = self.learningAtQuizService else {
            return LearningAtQuizService(
                userDefaultsRepository: makeUserDefaultsRepository(),
                commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository()
            )
        }
        
        return learningAtQuizService
    }
    
    func bookmarksUseCase() -> BookmarksUseCase {
        guard let bookmarksService = self.bookmarksService else {
            return BookmarksService(bookmarksRepository: makeBoookmarksRepository())
        }
        
        return bookmarksService
    }
    
    func searchKanjiUseCase() -> SearchKanjiUseCase {
        guard let searchKanjiService = self.searchKanjiService else {
            return SearchKanjiService(commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository())
        }
        
        return searchKanjiService
    }
    
    func iCloudBookmarksUseCase() -> ICloudBookmarksUseCase {
        guard let icloudBookmarksService = self.iCloudBookmarksService else {
            return ICloudBookmarksService(
                bookmarksRepository: makeBoookmarksRepository(),
                cloudKitBookmarksRepository: makeCloudKitBookmarksRepository(),
                userDefaultsRepository: makeUserDefaultsRepository()
            )
        }
        
        return icloudBookmarksService
    }
    
    func makeGetKanchuProblemsUsecase() -> GetKanchuProblemsUseCase {
        guard let getKanchuProblemsService = self.getKanchuProblemsService else {
            return DefaultGetKanchuProblemsService(kanchuRepository: makeKanchuRepository())
        }
        
        return getKanchuProblemsService
    }
    
    func makeCalculateKanchuProblemsResult() -> CalculateKanchuProblemsResultUseCase {
        guard let calculateKanchuProblemsResultervice = self.calculateKanchuProblemsResultervice else {
            return DefaultCalculateKanchuProblemsResultService()
        }
        
        return calculateKanchuProblemsResultervice
    }
    
    // MARK: - Repository
    private func makeCommonlyUsedKanjiRepository() -> CommonlyUsedKanjiRepository {
        DefaultCommonlyUsedKanjiRepository(commonlyUsedKanjiStorage: commonlyUsedKanjiStorage)
    }
    
    private func makeUserDefaultsRepository() -> UserDefaultsRepository {
        DefaultUserDefaultsRepository()
    }
    
    private func makeBoookmarksRepository() -> BookmarksRepository {
        DefaultBookmarksRepository(commonlyUsedKanjiStorage: commonlyUsedKanjiStorage)
    }
    
    private func makeCloudKitBookmarksRepository() -> CloudKitBookmarksRepository {
        DefaultsCloudKitBookmarksRepository(commonlyUsedKanjiStorage: commonlyUsedKanjiStorage)
    }
    
    private func makeKanchuRepository() -> KanchuRepository {
        return MockKanjiRepository()
    }
}
