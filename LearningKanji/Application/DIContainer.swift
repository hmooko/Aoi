
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
        
        self.todaysKanjiUseCaseCache = MockTodaysKanjiService()
        self.learningByGradeUseCaseCache = MockLearningByGradeService()
        self.learningAtQuizUseCaseCache = MockLearningAtQuizService()
        self.bookmarksUseCaseCache = MockBookmarksService()
        self.searchKanjiUseCaseCache = MockSearchKanjiService()
        self.iCloudBookmarksUseCaseCache = MockICloudBookmarksService()
        self.iCloudKanchuProjectUseCaseCache = MockICloudKanchuProjectService()
        self.iCloudGlobalBackupUseCaseCache = MockICloudGlobalBackupService()
        self.getKanchuProblemsUseCaseCache = MockGetKanchuProblemsService()
        self.calculateKanchuProblemsResultUseCaseCache = MockCalculateKanchuProblemsResultService()
        self.fetchAllKanchuProjectsUseCaseCache = MockFetchAllKanchuProjectsUseCase(kanchuProjectRepository: mockKanchuProjectRepository)
        self.insertKanchuProjectUseCaseCache = MockInsertKanchuProjectUseCase(kanchuProjectRepository: mockKanchuProjectRepository)
        self.deleteKanchuProjectUseCaseCache = MockDefaultDeleteKanchuProjectUseCase(kanchuProjectRepository: mockKanchuProjectRepository)
        self.renameKanchuProjectUseCaseCache = MockRenameKanchuProjectService(kanchuProjectRepository: mockKanchuProjectRepository)
        self.toggleKanchuProjectPinStateUseCaseCache = MockToggleKanchuProjectPinStateService(kanchuProjectRepository: mockKanchuProjectRepository)
        self.signInWithAppleUseCaseCache = MockSignInWithAppleService()
        self.getUserInfoUseCaseCache = MockGetUserInfoService()
        self.getCurrentUserUseCaseCache = MockGetCurrentUserService()
        self.signOutUseCaseCache = MockSignOutService()
        
        // Subscription Mocks
        self.fetchProductsUseCaseCache = MockFetchKanchuProductsUseCase()
        self.purchaseKanchuMonthlyProductUseCaseCache = MockPurchaseKanchuUseCase()
        self.restorePurchasesUseCaseCache = MockRestorePurchasesUseCase()
        self.observeTransactionsUseCaseCache = MockObserveTransactionsUseCase()
        self.checkSubscriptionStatusUseCaseCache = MockCheckSubscriptionStatusUseCase(mockStatus: .paidKanchuMonthly)
        self.getIsKanchuMonthlyIntroductoryOfferUseCaseCache = MockGetIsKanchuMonthlyIntroductoryOfferUseCase()
        
        // AI Model and API Key Mocks
        self.setAIModelUseCaseCache = MockSetAIModelService()
        self.getAIModelUseCaseCache = MockGetAIModelService()
        self.getKanchuAPIKeyUseCaseCache = MockGetKanchuAPIKeyService()
        self.setKanchuAPIKeyUseCaseCache = MockSetKanchuAPIKeyService()
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
    
    // MARK: - Use Case Properties
    private var todaysKanjiUseCaseCache: TodaysKanjiUseCase? = nil
    private var learningByGradeUseCaseCache: LearningByGradeUseCase? = nil
    private var learningAtQuizUseCaseCache: LearningAtQuizUseCase? = nil
    private var bookmarksUseCaseCache: BookmarksUseCase? = nil
    private var searchKanjiUseCaseCache: SearchKanjiUseCase? = nil
    private var iCloudBookmarksUseCaseCache: ICloudBookmarksUseCase? = nil
    private var iCloudKanchuProjectUseCaseCache: ICloudKanchuProjectUseCase? = nil
    private var iCloudGlobalBackupUseCaseCache: ICloudGlobalBackupUseCase? = nil
    private var getKanchuProblemsUseCaseCache: GetKanchuProblemsUseCase? = nil
    private var calculateKanchuProblemsResultUseCaseCache: CalculateKanchuProblemsResultUseCase? = nil
    private var fetchAllKanchuProjectsUseCaseCache: FetchAllKanchuProjectsUseCase? = nil
    private var insertKanchuProjectUseCaseCache: InsertKanchuProjectUseCase? = nil
    private var deleteKanchuProjectUseCaseCache: DeleteKanchuProjectUseCase? = nil
    private var renameKanchuProjectUseCaseCache: RenameKanchuProjectUseCase? = nil
    private var toggleKanchuProjectPinStateUseCaseCache: ToggleKanchuProjectPinStateUseCase? = nil
    private var signInWithAppleUseCaseCache: SignInWithAppleUseCase?
    private var getUserInfoUseCaseCache: GetUserInfoUseCase? = nil
    private var getCurrentUserUseCaseCache: GetCurrentUserUseCase? = nil
    private var signOutUseCaseCache: SignOutUseCase? = nil
    
    // Subscription Use Cases
    private var fetchProductsUseCaseCache: FetchProductsUseCase? = nil
    private var purchaseKanchuMonthlyProductUseCaseCache: PurchaseKanchuMonthlyProductUseCase? = nil
    private var restorePurchasesUseCaseCache: RestorePurchasesUseCase? = nil
    private var observeTransactionsUseCaseCache: ObserveTransactionsUseCase? = nil
    private var checkSubscriptionStatusUseCaseCache: CheckSubscriptionStatusUseCase? = nil
    private var getIsKanchuMonthlyIntroductoryOfferUseCaseCache: GetIsKanchuMonthlyIntroductoryOfferUseCase? = nil
    
    // AI and API Key Use Cases
    private var setAIModelUseCaseCache: SetAIModelUseCase? = nil
    private var getAIModelUseCaseCache: GetAIModelUseCase? = nil
    private var getKanchuAPIKeyUseCaseCache: GetKanchuAPIKeyUseCase? = nil
    private var setKanchuAPIKeyUseCaseCache: SetKanchuAPIKeyUseCase? = nil

    
    // MARK: - Storage
    private let commonlyUsedKanjiStorage = CommonlyUsedKanjiStorage.shared

    
    // MARK: - Use Case Factory Methods
    func todaysKanjiUseCase() -> TodaysKanjiUseCase {
        if let useCase = self.todaysKanjiUseCaseCache {
            return useCase
        }
        let newUseCase = TodaysKanjiService(
            commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository(),
            userDefaultsRepository: makeUserDefaultsRepository()
        )
        self.todaysKanjiUseCaseCache = newUseCase
        return newUseCase
    }
    
    func learningByGradeUseCase() -> LearningByGradeUseCase {
        if let useCase = self.learningByGradeUseCaseCache {
            return useCase
        }
        let newUseCase = LearningByGradeService(commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository())
        self.learningByGradeUseCaseCache = newUseCase
        return newUseCase
    }
    
    func learningAtQuizUseCase() -> LearningAtQuizUseCase {
        if let useCase = self.learningAtQuizUseCaseCache {
            return useCase
        }
        let newUseCase = LearningAtQuizService(
            userDefaultsRepository: makeUserDefaultsRepository(),
            commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository()
        )
        self.learningAtQuizUseCaseCache = newUseCase
        return newUseCase
    }
    
    func bookmarksUseCase() -> BookmarksUseCase {
        if let useCase = self.bookmarksUseCaseCache {
            return useCase
        }
        let newUseCase = BookmarksService(bookmarksRepository: makeBoookmarksRepository())
        self.bookmarksUseCaseCache = newUseCase
        return newUseCase
    }
    
    func searchKanjiUseCase() -> SearchKanjiUseCase {
        if let useCase = self.searchKanjiUseCaseCache {
            return useCase
        }
        let newUseCase = SearchKanjiService(commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository())
        self.searchKanjiUseCaseCache = newUseCase
        return newUseCase
    }
    
    func iCloudBookmarksUseCase() -> ICloudBookmarksUseCase {
        if let useCase = self.iCloudBookmarksUseCaseCache {
            return useCase
        }
        let newUseCase = ICloudBookmarksService(
            bookmarksRepository: makeBoookmarksRepository(),
            cloudKitBookmarksRepository: makeCloudKitBookmarksRepository()
        )
        self.iCloudBookmarksUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func iCloudKanchuProjectUseCase() -> ICloudKanchuProjectUseCase {
        if let useCase = self.iCloudKanchuProjectUseCaseCache {
            return useCase
        }
        let newUseCase = ICloudKanchuProjectService(
            kanchuProjectRepository: makeKanchuProjectRepository(),
            cloudKitKanchuProjectRepository: makeCloudKitKanchuProjectRepository()
        )
        self.iCloudKanchuProjectUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func iCloudGlobalBackupUseCase() -> ICloudGlobalBackupUseCase {
        if let useCase = self.iCloudGlobalBackupUseCaseCache {
            return useCase
        }
        let newUseCase = ICloudGlobalBackupService(
            bookmarksBackupService: iCloudBookmarksUseCase(),
            kanchuProjectBackupService: iCloudKanchuProjectUseCase(),
            userDefaultsRepository: makeUserDefaultsRepository()
        )
        self.iCloudGlobalBackupUseCaseCache = newUseCase
        return newUseCase
    }
    
    func getKanchuProblemsUsecase() throws -> GetKanchuProblemsUseCase {
        if let useCase = self.getKanchuProblemsUseCaseCache {
            return useCase
        }
        let newUseCase = try DefaultGetKanchuProblemsService(
            geminiKanchuRepository: makeGeminiKanchuQuizRepository(),
            bookmarksRepository: makeBoookmarksRepository(),
            commonlyUsedKanjiRepository: makeCommonlyUsedKanjiRepository(),
            userDefaultsRepsoitory: makeUserDefaultsRepository()
        )
        self.getKanchuProblemsUseCaseCache = newUseCase
        return newUseCase
    }
    
    func calculateKanchuProblemsResult() -> CalculateKanchuProblemsResultUseCase {
        if let useCase = self.calculateKanchuProblemsResultUseCaseCache {
            return useCase
        }
        let newUseCase = DefaultCalculateKanchuProblemsResultService()
        self.calculateKanchuProblemsResultUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func fetchAllKanchuProjectsUseCase() -> FetchAllKanchuProjectsUseCase {
        if let useCase = self.fetchAllKanchuProjectsUseCaseCache {
            return useCase
        }
        let newUseCase = DefaultFetchAllKanchuProjectsUseCase(kanchuRepository: makeKanchuProjectRepository())
        self.fetchAllKanchuProjectsUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func insertKanchuProjectUseCase() -> InsertKanchuProjectUseCase {
        if let useCase = self.insertKanchuProjectUseCaseCache {
            return useCase
        }
        let newUseCase = DefaultInsertKanchuProjectUseCase(kanchuRepository: makeKanchuProjectRepository())
        self.insertKanchuProjectUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func deleteKanchuProjectUseCase() -> DeleteKanchuProjectUseCase {
        if let useCase = self.deleteKanchuProjectUseCaseCache {
            return useCase
        }
        let newUseCase = DefaultDeleteKanchuProjectUseCase(kanchuRepository: makeKanchuProjectRepository())
        self.deleteKanchuProjectUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func renameKanchuProjectUseCase() -> RenameKanchuProjectUseCase {
        if let useCase = self.renameKanchuProjectUseCaseCache {
            return useCase
        }
        let newUseCase = RenameKanchuProjectService(kanchuProjectRepository: makeKanchuProjectRepository())
        self.renameKanchuProjectUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func toggleKanchuProjectPinStateUseCase() -> ToggleKanchuProjectPinStateUseCase {
        if let useCase = self.toggleKanchuProjectPinStateUseCaseCache {
            return useCase
        }
        let newUseCase = ToggleKanchuProjectPinStateService(kanchuProjectRepository: makeKanchuProjectRepository())
        self.toggleKanchuProjectPinStateUseCaseCache = newUseCase
        return newUseCase
    }
    
    func signInWithAppleUseCase() -> SignInWithAppleUseCase {
        if let useCase = self.signInWithAppleUseCaseCache {
            return useCase
        }
        let newUseCase = SignInWithAppleService(authRepository: makeAuthRepository(), userRepository: makeUserRepository())
        self.signInWithAppleUseCaseCache = newUseCase
        return newUseCase
    }
    
    func getUserInfoUseCase() -> GetUserInfoUseCase {
        if let useCase = self.getUserInfoUseCaseCache {
            return useCase
        }
        let newUseCase = DefaultGetUserInfoService(userRepository: makeUserRepository())
        self.getUserInfoUseCaseCache = newUseCase
        return newUseCase
    }

    func getCurrentUserUseCase() -> GetCurrentUserUseCase {
        if let useCase = self.getCurrentUserUseCaseCache {
            return useCase
        }
        let newUseCase = DefaultGetCurrentUserService(authRepository: makeAuthRepository())
        self.getCurrentUserUseCaseCache = newUseCase
        return newUseCase
    }

    func signOutUseCase() -> SignOutUseCase {
        if let useCase = self.signOutUseCaseCache {
            return useCase
        }
        let newUseCase = SignOutService(authRepository: makeAuthRepository())
        self.signOutUseCaseCache = newUseCase
        return newUseCase
    }
    
    // Subscription Use Cases
    @MainActor
    func fetchProductsUseCase() -> FetchProductsUseCase {
        if let useCase = self.fetchProductsUseCaseCache {
            return useCase
        }
        let newUseCase = FetchProductsService(subscriptionRepository: makeSubscriptionRepository())
        self.fetchProductsUseCaseCache = newUseCase
        return newUseCase
    }

    @MainActor
    func purchaseKanchuMonthlyProductUseCase() -> PurchaseKanchuMonthlyProductUseCase {
        if let useCase = self.purchaseKanchuMonthlyProductUseCaseCache {
            return useCase
        }
        let newUseCase = PurchaseKanchuMonthlyProductService(subscriptionRepository: makeSubscriptionRepository())
        self.purchaseKanchuMonthlyProductUseCaseCache = newUseCase
        return newUseCase
    }

    @MainActor
    func restorePurchasesUseCase() -> RestorePurchasesUseCase {
        if let useCase = self.restorePurchasesUseCaseCache {
            return useCase
        }
        let newUseCase = RestorePurchasesService(subscriptionRepository: makeSubscriptionRepository())
        self.restorePurchasesUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func observeTransactionsUseCase() -> ObserveTransactionsUseCase {
        if let useCase = self.observeTransactionsUseCaseCache {
            return useCase
        }
        let newUseCase = ObserveTransactionsService(subscriptionRepository: makeSubscriptionRepository())
        self.observeTransactionsUseCaseCache = newUseCase
        return newUseCase
    }

    @MainActor
    func checkSubscriptionStatusUseCase() -> CheckSubscriptionStatusUseCase {
        if let useCase = self.checkSubscriptionStatusUseCaseCache {
            return useCase
        }
        let newUseCase = CheckSubscriptionStatusService(subscriptionRepository: makeSubscriptionRepository())
        self.checkSubscriptionStatusUseCaseCache = newUseCase
        return newUseCase
    }
    
    @MainActor
    func getIsKanchuMonthlyIntroductoryOfferUseCase() -> GetIsKanchuMonthlyIntroductoryOfferUseCase {
        if let useCase = self.getIsKanchuMonthlyIntroductoryOfferUseCaseCache {
            return useCase
        }
        let newUseCase = GetIsKanchuMonthlyIntroductoryOfferService(subscriptionRepository: makeSubscriptionRepository())
        self.getIsKanchuMonthlyIntroductoryOfferUseCaseCache = newUseCase
        return newUseCase
    }
    
    func setAIModelUseCase() -> SetAIModelUseCase {
        if let useCase = self.setAIModelUseCaseCache {
            return useCase
        }
        let newUseCase = SetAIModelService(userDefaultsRepository: makeUserDefaultsRepository())
        self.setAIModelUseCaseCache = newUseCase
        return newUseCase
    }

    func getAIModelUseCase() -> GetAIModelUseCase {
        if let useCase = self.getAIModelUseCaseCache {
            return useCase
        }
        let newUseCase = GetAIModelService(userDefaultsRepository: makeUserDefaultsRepository())
        self.getAIModelUseCaseCache = newUseCase
        return newUseCase
    }
    
    func getKanchuAPIKeyUseCase() -> GetKanchuAPIKeyUseCase {
        if let useCase = self.getKanchuAPIKeyUseCaseCache {
            return useCase
        }
        let newUseCase = GetKanchuAPIKeyService(userDefaultsRepository: makeUserDefaultsRepository())
        self.getKanchuAPIKeyUseCaseCache = newUseCase
        return newUseCase
    }

    func setKanchuAPIKeyUseCase() -> SetKanchuAPIKeyUseCase {
        if let useCase = self.setKanchuAPIKeyUseCaseCache {
            return useCase
        }
        let newUseCase = SetKanchuAPIKeyService(userDefaultsRepository: makeUserDefaultsRepository())
        self.setKanchuAPIKeyUseCaseCache = newUseCase
        return newUseCase
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
    
    private func makeCloudKitKanchuProjectRepository() -> CloudKitKanchuProjectRepository {
        DefaultCloudKitKanchuProjectRepository()
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
