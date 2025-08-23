//
//  KanchuHomeViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/25.
//

import Foundation
import os

extension KanchuHomeView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "KanchuHomeViewModel")
        
        // MARK: - Use Cases
        private let fetchAllKanchuProjectsUseCase: FetchAllKanchuProjectsUseCase
        private let deleteKanchuProjectUseCase: DeleteKanchuProjectUseCase
        private let renameKanchuProjectUseCase: RenameKanchuProjectUseCase
        private let toggleKanchuProjectPinStateUseCase: ToggleKanchuProjectPinStateUseCase
        
        private let purchaseKanchuMonthlyProductUseCase: PurchaseKanchuMonthlyProductUseCase
        private let restorePurchasesUseCase: RestorePurchasesUseCase
        private let checkSubscriptionStatusUseCase: CheckSubscriptionStatusUseCase
        private let observeTransactionsUseCase: ObserveTransactionsUseCase
        private let getIsKanchuMonthlyIntroProductoryOfferUseCase: GetIsKanchuMonthlyIntroductoryOfferUseCase
        
        // MARK: - Properties
        private(set) var router: Router
        private var transactionObserver: Task<Void, Never>?
        
        // MARK: - Published Properties
        @Published private(set) var projects: [KanchuProject] = []
        @Published private(set) var viewState: ViewState = .loading
        @Published var projectToRename: KanchuProject?
        @Published var newProjectName: String = ""
        @Published var showPaywallOverlay: Bool = false
        @Published private(set) var subscriptionStatus: SubscriptionStatus = .free
        @Published private(set) var isKanchuMonthlyIntroductoryOffer: Bool = false
        
        enum ViewState: Equatable {
            case loading
            case loaded
            case error(String)
        }
        
        init(container: DIContainer) {
            // Project Use Cases
            self.fetchAllKanchuProjectsUseCase = container.fetchAllKanchuProjectsUseCase()
            self.deleteKanchuProjectUseCase = container.deleteKanchuProjectUseCase()
            self.renameKanchuProjectUseCase = container.renameKanchuProjectUseCase()
            self.toggleKanchuProjectPinStateUseCase = container.toggleKanchuProjectPinStateUseCase()
            
            // Subscription Use Cases
            self.purchaseKanchuMonthlyProductUseCase = container.purchaseKanchuMonthlyProductUseCase()
            self.restorePurchasesUseCase = container.restorePurchasesUseCase()
            self.checkSubscriptionStatusUseCase = container.checkSubscriptionStatusUseCase()
            self.observeTransactionsUseCase = container.observeTransactionsUseCase()
            self.getIsKanchuMonthlyIntroProductoryOfferUseCase = container.getIsKanchuMonthlyIntroductoryOfferUseCase()
            
            self.router = container.router
            logger.info("KanchuHomeViewModel이 초기화되었습니다.")
            
            // Initial Subscription Setup
            Task {
                await updateSubscriptionStatus()
                await updateIsKanchuMonthlyIntroductoryOffer()
            }
            observeTransactions()
        }
        
        deinit {
            transactionObserver?.cancel()
            logger.info("KanchuHomeViewModel이 메모리에서 해제되고, 트랜잭션 관찰을 중단합니다.")
        }
        
        // MARK: - Project Functions
        
        func fetchAllKanchuProjects() {
            logger.debug("모든 Kanchu 프로젝트를 가져옵니다.")
            viewState = .loading
            Task {
                do {
                    let projects = try await fetchAllKanchuProjectsUseCase.execute(sortOption: .createdAt(ascending: true))
                    self.projects = projects
                    self.viewState = .loaded
                    logger.info("\(projects.count)개의 프로젝트를 성공적으로 가져왔습니다.")
                } catch {
                    let errorMessage = "모든 Kanchu 프로젝트를 가져오는 중 오류 발생: \(error.localizedDescription)"
                    logger.error("\(errorMessage)")
                    self.viewState = .error(errorMessage)
                }
            }
        }
        
        func togglePin(for project: KanchuProject) {
            logger.debug("프로젝트 \(project.id)의 핀 상태를 변경합니다.")
            Task {
                do {
                    _ = try await toggleKanchuProjectPinStateUseCase.execute(project: project)
                    self.fetchAllKanchuProjects()
                } catch {
                    logger.error("프로젝트 \(project.id)의 핀 상태 변경 중 오류 발생: \(error.localizedDescription)")
                    self.viewState = .error("핀 상태 변경에 실패했습니다.")
                }
            }
        }
        
        func createQuiz() {
            logger.debug("KanchuQuizScene으로 이동합니다.")
            router.push(.kanchuQuizScene)
        }
        
        func deleteProject(_ project: KanchuProject) {
            logger.debug("프로젝트 \(project.id) 삭제를 시도합니다.")
            Task {
                do {
                    try await deleteKanchuProjectUseCase.execute(ids: [project.id])
                    logger.info("프로젝트 \(project.id)를 성공적으로 삭제했습니다. UI에서 제거합니다.")
                    projects.removeAll { $0.id == project.id }
                } catch {
                    let errorMessage = "프로젝트 \(project.id) 삭제 중 오류 발생: \(error.localizedDescription)"
                    logger.error("\(errorMessage)")
                    self.viewState = .error("프로젝트 삭제에 실패했습니다.")
                }
            }
        }
        
        func selectProjectToRename(_ project: KanchuProject) {
            logger.debug("프로젝트 \(project.id, privacy: .public) 이름 변경을 시작합니다.")
            self.projectToRename = project
            self.newProjectName = project.name
        }

        func cancelProjectRename() {
            self.projectToRename = nil
            self.newProjectName = ""
        }

        func commitProjectRename() {
            guard let project = projectToRename else {
                logger.warning("이름을 변경할 프로젝트가 선택되지 않았습니다.")
                return
            }
            
            let nameToSet = newProjectName
            
            guard !nameToSet.isEmpty, nameToSet != project.name else {
                logger.info("프로젝트 이름이 변경되지 않았거나 비어있어 작업을 취소합니다.")
                cancelProjectRename()
                return
            }
            
            logger.debug("프로젝트 \(project.id, privacy: .public)의 이름을 '\(nameToSet, privacy: .public)'(으)로 변경합니다.")
            Task {
                do {
                    let updatedProject = try await renameKanchuProjectUseCase.execute(project: project, newName: nameToSet)
                    
                    if let index = self.projects.firstIndex(where: { $0.id == project.id }) {
                        self.projects[index] = updatedProject
                    }
                    self.cancelProjectRename()
                    logger.info("프로젝트 \(project.id, privacy: .public)의 이름을 성공적으로 변경했습니다.")
                    
                } catch {
                    let errorMessage = "프로젝트 \(project.id)의 이름 변경 중 오류 발생: \(error.localizedDescription)"
                    logger.error("\(errorMessage)")
                    self.viewState = .error("이름 변경에 실패했습니다.")
                    self.cancelProjectRename()
                }
            }
        }
        
        func startQuiz(project: KanchuProject) {
            router.push(.kanchuQuizWithProjectScene(project))
        }
        
        // MARK: - Subscription Functions
        
        func purchaseKanchuMonthlyProduct() {
            viewState = .loading
            logger.debug("월간 구독 상품 구매를 시작합니다.")
            Task {
                do {
                    try await purchaseKanchuMonthlyProductUseCase.execute()
                    await updateSubscriptionStatus()
                    logger.info("월간 구독 상품 구매가 완료되었습니다.")
                    viewState = .loaded
                } catch {
                    let errorMessage = "월간 구독 상품 구매 중 오류 발생: \(error.localizedDescription)"
                    logger.error("\(errorMessage)")
                    viewState = .error(errorMessage)
                }
            }
        }

        func restorePurchases() {
            viewState = .loading
            logger.debug("구매 내역 복원을 시작합니다.")
            Task {
                await restorePurchasesUseCase.execute()
                await updateSubscriptionStatus()
                logger.info("구매 내역 복원이 완료되었습니다.")
                viewState = .loaded
            }
        }
        
        private func updateIsKanchuMonthlyIntroductoryOffer() async {
            viewState = .loading
            logger.debug("월간 introductory offer 여부를 확인합니다.")
            do {
                self.isKanchuMonthlyIntroductoryOffer = try await getIsKanchuMonthlyIntroProductoryOfferUseCase.excute()
            } catch {
                viewState = .error("월간 introductory offer 여부를 확인하는 데 오류가 발생했습니다: \(error.localizedDescription)")
            }
            logger.info("월간 introductory offer 여부를 확인하였습니다.")
            viewState = .loaded
        }

        private func updateSubscriptionStatus() async {
            logger.debug("구독 상태를 업데이트합니다.")
            let newStatus = await checkSubscriptionStatusUseCase.execute()
            if subscriptionStatus != newStatus {
                subscriptionStatus = newStatus
                logger.info("현재 구독 상태: \(self.subscriptionStatus.description())")
            }
        }

        private func observeTransactions() {
            logger.debug("거래 관찰을 시작합니다.")
            self.transactionObserver = Task {
                for await _ in observeTransactionsUseCase.execute() {
                    // 외부에서 거래 변경이 감지되면(갱신, 환불 등)
                    // 사용자의 현재 상태를 다시 확인합니다.
                    logger.info("새로운 거래 변경이 감지되었습니다. 구독 상태를 갱신합니다.") // 거래 감지 로깅
                    await updateSubscriptionStatus()
                    await updateIsKanchuMonthlyIntroductoryOffer()
                }
                logger.info("거래 관찰이 종료되었습니다.") // 관찰 종료 로깅 (Task가 취소될 경우)
            }
        }
    }
}
