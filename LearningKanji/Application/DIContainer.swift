//
//  LearningKanjiSceneDIContainer.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import Foundation
import SwiftData

final class DIContainer: ObservableObject {
    // MARK: - Mock
    @MainActor
    static var preview: Self {
        let container = DIContainer()
        container.setMockServices()
        return container as! Self
    }
    
    @MainActor
    func setMockServices() {
        let mockKanchuProjectRepository = MockKanchuProjectRepository(initialProjects: createExampleProjects())
        
        self.todaysKanjiService = MockTodaysKanjiService()
        self.learningByGradeService = MockLearningByGradeService()
        self.learningAtQuizService = MockLearningAtQuizService()
        self.bookmarksService = MockBookmarksService()
        self.searchKanjiService = MockSearchKanjiService()
        self.iCloudBookmarksService = MockICloudBookmarksService()
        self.getKanchuProblemsService = MockGetKanchuProblemsService()
        self.calculateKanchuProblemsResultService = MockCalculateKanchuProblemsResultService()
        self.fetchAllKanchuProjectsService = MockFetchAllKanchuProjectsUseCase(kanchuProjectRepository: mockKanchuProjectRepository)
        self.insertKanchuProjectService = MockInsertKanchuProjectUseCase(kanchuProjectRepository: mockKanchuProjectRepository)
        self.deleteKanchuProjectService = MockDefaultDeleteKanchuProjectUseCase(kanchuProjectRepository: mockKanchuProjectRepository)
        self.renameKanchuProjectService = MockRenameKanchuProjectService(kanchuProjectRepository: mockKanchuProjectRepository)
        self.toggleKanchuProjectPinStateService = MockToggleKanchuProjectPinStateService(kanchuProjectRepository: mockKanchuProjectRepository)
        self.signInWithAppleService = MockSignInWithAppleService()
        self.getUserInfoService = MockGetUserInfoService()
        self.getCurrentUserService = MockGetCurrentUserService()
        self.signOutService = MockSignOutService()
        
        // Subscription Mocks
        self.fetchKanchuProductsService = MockFetchKanchuProductsUseCase()
        self.purchaseKanchuService = MockPurchaseKanchuUseCase()
        self.restorePurchasesService = MockRestorePurchasesUseCase()
        self.observeTransactionsService = MockObserveTransactionsUseCase()
        self.checkSubscriptionStatusService = MockCheckSubscriptionStatusUseCase()
        
        // AI Model and API Key Mocks
        self.setAIModelService = MockSetAIModelService()
        self.getAIModelService = MockGetAIModelService()
        self.getKanchuAPIKeyService = MockGetKanchuAPIKeyService()
        self.setKanchuAPIKeyService = MockSetKanchuAPIKeyService()
    }
    
    // MARK: - Model
    lazy var modelContainer: ModelContainer = {
        let schema = Schema([
            KanchuProjectDTO.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @MainActor
    var modelContext: ModelContext {
        modelContainer.mainContext
    }
    
    var router: Router = Router()
    
    // MARK: - Services
    private var todaysKanjiService: TodaysKanjiUseCase? = nil
    private var learningByGradeService: LearningByGradeUseCase? = nil
    private var learningAtQuizService: LearningAtQuizUseCase? = nil
    private var bookmarksService: BookmarksUseCase? = nil
    private var searchKanjiService: SearchKanjiUseCase? = nil
    private var iCloudBookmarksService: ICloudBookmarksUseCase? = nil
    private var getKanchuProblemsService: GetKanchuProblemsUseCase? = nil
    private var calculateKanchuProblemsResultService: CalculateKanchuProblemsResultUseCase? = nil
    private var fetchAllKanchuProjectsService: FetchAllKanchuProjectsUseCase? = nil
    private var insertKanchuProjectService: InsertKanchuProjectUseCase? = nil
    private var deleteKanchuProjectService: DeleteKanchuProjectUseCase? = nil
    private var renameKanchuProjectService: RenameKanchuProjectUseCase? = nil
    private var toggleKanchuProjectPinStateService: ToggleKanchuProjectPinStateUseCase? = nil
    private var signInWithAppleService: SignInWithAppleUseCase?
    private var getUserInfoService: GetUserInfoUseCase? = nil
    private var getCurrentUserService: GetCurrentUserUseCase? = nil
    private var signOutService: SignOutUseCase? = nil
    
    // Subscription Services
    private var fetchKanchuProductsService: FetchProductsUseCase? = nil
    private var purchaseKanchuService: PurchaseKanchuMonthlyProductUseCase? = nil
    private var restorePurchasesService: RestorePurchasesUseCase? = nil
    private var observeTransactionsService: ObserveTransactionsUseCase? = nil
    private var checkSubscriptionStatusService: CheckSubscriptionStatusUseCase? = nil
    
    private var setAIModelService: SetAIModelUseCase? = nil
    private var getAIModelService: GetAIModelUseCase? = nil
    private var getKanchuAPIKeyService: GetKanchuAPIKeyUseCase? = nil
    private var setKanchuAPIKeyService: SetKanchuAPIKeyUseCase? = nil

    
    // MARK: - Storage
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
                geminiKanchuRepository: try makeGeminiKanchuQuizRepository(),
                bookmarksRepository: makeBoookmarksRepository(),
                commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository(),
                userDefaultsRepsoitory: makeUserDefaultsRepository()
            )
        }
        
        return getKanchuProblemsService
    }
    
    func calculateKanchuProblemsResult() -> CalculateKanchuProblemsResultUseCase {
        guard let calculateKanchuProblemsResultService = self.calculateKanchuProblemsResultService else {
            return DefaultCalculateKanchuProblemsResultService()
        }
        
        return calculateKanchuProblemsResultService
    }
    
    @MainActor
    func fetchAllKanchuProjectsUseCase() -> FetchAllKanchuProjectsUseCase {
        guard let fetchAllKanchuProjectsService = self.fetchAllKanchuProjectsService else {
            return DefaultFetchAllKanchuProjectsUseCase(kanchuRepository: makeKanchuProjectRepository())
        }
        return fetchAllKanchuProjectsService
    }
    
    @MainActor
    func insertKanchuProjectUseCase() -> InsertKanchuProjectUseCase {
        guard let insertKanchuProjectService = self.insertKanchuProjectService else {
            return DefaultInsertKanchuProjectUseCase(kanchuRepository: makeKanchuProjectRepository())
        }
        return insertKanchuProjectService
    }
    
    @MainActor
    func deleteKanchuProjectUseCase() -> DeleteKanchuProjectUseCase {
        guard let deleteKanchuProjectService = self.deleteKanchuProjectService else {
            return DefaultDeleteKanchuProjectUseCase(kanchuRepository: makeKanchuProjectRepository())
        }
        return deleteKanchuProjectService
    }
    
    @MainActor
    func renameKanchuProjectUseCase() -> RenameKanchuProjectUseCase {
        guard let renameKanchuProjectService = self.renameKanchuProjectService else {
            return RenameKanchuProjectService(kanchuProjectRepository: makeKanchuProjectRepository())
        }
        return renameKanchuProjectService
    }
    
    @MainActor
    func toggleKanchuProjectPinStateUseCase() -> ToggleKanchuProjectPinStateUseCase {
        guard let toggleKanchuProjectPinStateService = self.toggleKanchuProjectPinStateService else {
            return ToggleKanchuProjectPinStateService(kanchuProjectRepository: makeKanchuProjectRepository())
        }
        return toggleKanchuProjectPinStateService
    }
    
    func signInWithAppleUseCase() -> SignInWithAppleUseCase {
        guard let signInWithAppleService = self.signInWithAppleService else {
            return SignInWithAppleService(authRepository: makeAuthRepository(), userRepository: makeUserRepository())
        }
        return signInWithAppleService
    }
    
    func getUserInfoUseCase() -> GetUserInfoUseCase {
        guard let getUserInfoService = self.getUserInfoService else {
            return DefaultGetUserInfoService(userRepository: makeUserRepository())
        }
        return getUserInfoService
    }

    func getCurrentUserUseCase() -> GetCurrentUserUseCase {
        guard let getCurrentUserService = self.getCurrentUserService else {
            return DefaultGetCurrentUserService(authRepository: makeAuthRepository())
        }
        return getCurrentUserService
    }

    func signOutUseCase() -> SignOutUseCase {
        guard let signOutService = self.signOutService else {
            return SignOutService(authRepository: makeAuthRepository())
        }
        return signOutService
    }
    
    // Subscription Use Cases
    @MainActor
    func fetchProductsUseCase() -> FetchProductsUseCase {
        guard let service = self.fetchKanchuProductsService else {
            return FetchProductsService(subscriptionRepository: makeSubscriptionRepository())
        }
        return service
    }

    @MainActor
    func purchaseKanchuMonthlyProductUseCase() -> PurchaseKanchuMonthlyProductUseCase {
        guard let service = self.purchaseKanchuService else {
            return PurchaseKanchuMonthlyProductService(subscriptionRepository: makeSubscriptionRepository())
        }
        return service
    }

    @MainActor
    func restorePurchasesUseCase() -> RestorePurchasesUseCase {
        guard let service = self.restorePurchasesService else {
            return RestorePurchasesService(subscriptionRepository: makeSubscriptionRepository())
        }
        return service
    }
    
    @MainActor
    func observeTransactionsUseCase() -> ObserveTransactionsUseCase {
        guard let service = self.observeTransactionsService else {
            return ObserveTransactionsService(subscriptionRepository: makeSubscriptionRepository())
        }
        return service
    }

    @MainActor
    func checkSubscriptionStatusUseCase() -> CheckSubscriptionStatusUseCase {
        guard let service = self.checkSubscriptionStatusService else {
            return CheckSubscriptionStatusService(subscriptionRepository: makeSubscriptionRepository())
        }
        return service
    }
    
    func setAIModelUseCase() -> SetAIModelUseCase {
        guard let service = self.setAIModelService else {
            return SetAIModelService(userDefaultsRepository: makeUserDefaultsRepository())
        }
        return service
    }

    func getAIModelUseCase() -> GetAIModelUseCase {
        guard let service = self.getAIModelService else {
            return GetAIModelService(userDefaultsRepository: makeUserDefaultsRepository())
        }
        return service
    }
    
    func getKanchuAPIKeyUseCase() -> GetKanchuAPIKeyUseCase {
        guard let service = self.getKanchuAPIKeyService else {
            return GetKanchuAPIKeyService(userDefaultsRepository: makeUserDefaultsRepository())
        }
        return service
    }

    func setKanchuAPIKeyUseCase() -> SetKanchuAPIKeyUseCase {
        guard let service = self.setKanchuAPIKeyService else {
            return SetKanchuAPIKeyService(userDefaultsRepository: makeUserDefaultsRepository())
        }
        return service
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
    
    private func makeGeminiKanchuQuizRepository() throws -> GeminiKanchuQuizRepository {
        return try DefaultGeminiKanchuQuizRepository(userDefaultsRepository: makeUserDefaultsRepository())
    }
    
    @MainActor
    private func makeKanchuProjectRepository() -> KanchuProjectRepository {
        // return MockKanchuProjectRepository()
        DefaultKanchuProjectRepository(context: modelContext)
    }
    
    private func makeUserRepository() -> UserRepository {
        DefaultUserRepository()
    }
   
    private func makeAuthRepository() -> AuthRepository {
        DefaultAuthRepository()
    }

    // MARK: - Subscription
    @MainActor
    func makeSubscriptionRepository() -> SubscriptionRepository {
        DefaultSubscriptionRepository()
    }
}
