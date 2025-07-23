//
//  LearningKanjiSceneDIContainer.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation
import SwiftUI

final class DIContainer: ObservableObject {
    static var preview: Self {
        let container = DIContainer()
        container.setMockServices()
        return container as! Self
    }
    
    func setMockServices() {
        self.todaysKanjiService = MockTodaysKanjiService() // TODO: Create this mock if it doesn't exist yet.
        self.learningByGradeService = MockLearningByGradeService() // TODO: Create this mock if it doesn't exist yet.
        self.learningAtQuizService = MockLearningAtQuizService() // TODO: Create this mock if it doesn't exist yet.
        self.bookmarksService = MockBookmarksService() // TODO: Create this mock if it doesn't exist yet.
        self.searchKanjiService = MockSearchKanjiService() // TODO: Create this mock if it doesn't exist yet.
        self.iCloudBookmarksService = MockICloudBookmarksService() // TODO: Create this mock if it doesn't exist yet.
        self.getKanchuProblemsService = MockGetKanchuProblemsService() // TODO: Create this mock if it doesn't exist yet.
        self.calculateKanchuProblemsResultervice = MockCalculateKanchuProblemsResultService() // TODO: Create this mock if it doesn't exist yet.
    }
    
    // MARK: - Services
    private var todaysKanjiService: TodaysKanjiUseCase? = nil
    private var learningByGradeService: LearningByGradeUseCase? = nil
    private var learningAtQuizService: LearningAtQuizUseCase? = nil
    private var bookmarksService: BookmarksUseCase? = nil
    private var searchKanjiService: SearchKanjiUseCase? = nil
    private var iCloudBookmarksService: ICloudBookmarksUseCase? = nil
    private var getKanchuProblemsService: GetKanchuProblemsUseCase? = nil
    private var calculateKanchuProblemsResultervice: CalculateKanchuProblemsResultUseCase? = nil
    
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
    
    func getKanchuProblemsUsecase() throws -> GetKanchuProblemsUseCase {
        guard let getKanchuProblemsService = self.getKanchuProblemsService else {
            return DefaultGetKanchuProblemsService(
                kanchuRepository: try makeKanchuRepository(),
                bookmarksRepository: makeBoookmarksRepository(),
                commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository()
            )
        }
        
        return getKanchuProblemsService
    }
    
    func calculateKanchuProblemsResult() -> CalculateKanchuProblemsResultUseCase {
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
    
    private func makeKanchuRepository() throws -> KanchuQuizRepository {
        return try DefaultKanchuQuizRepository()
    }
}

