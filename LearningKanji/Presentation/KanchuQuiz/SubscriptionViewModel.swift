//
//  PayWallViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import Foundation
import os // os 프레임워크 임포트

extension KanchuHomeView {
    @MainActor
    final class SubscriptionViewModel: ObservableObject {
        // MARK: - Published Properties (View가 관찰할 상태)
        
        /// 현재 사용자의 구독 상태
        @Published private(set) var status: SubscriptionStatus = .free
        
        /// 데이터 로딩이나 구매 처리 중인지 여부
        @Published private(set) var isLoading: Bool = false
        
        /// 처리 중 발생한 에러
        @Published var error: Error?

        // MARK: - Use Cases (Domain 계층의 비즈니스 로직)
        
        private let purchaseKanchuMonthlyProductUseCase: PurchaseKanchuMonthlyProductUseCase
        private let restorePurchasesUseCase: RestorePurchasesUseCase
        private let checkSubscriptionStatusUseCase: CheckSubscriptionStatusUseCase
        private let observeTransactionsUseCase: ObserveTransactionsUseCase
        
        private var transactionObserver: Task<Void, Never>? = nil
        
        // MARK: - Logging
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "SubscriptionViewModel") // Logger 인스턴스 추가

        // MARK: - Initialization
        init(container: DIContainer) {
            purchaseKanchuMonthlyProductUseCase = container.purchaseKanchuMonthlyProductUseCase()
            restorePurchasesUseCase = container.restorePurchasesUseCase()
            checkSubscriptionStatusUseCase = container.checkSubscriptionStatusUseCase()
            observeTransactionsUseCase = container.observeTransactionsUseCase()
            
            logger.info("SubscriptionViewModel이 초기화되었습니다.") // 초기화 로깅
            
            Task {
                await updateSubscriptionStatus()
            }
            
            observeTransactions()
        }
        
        deinit {
            transactionObserver?.cancel()
            logger.info("SubscriptionViewModel이 해제됩니다.") // 해제 로깅
        }
        
        // MARK: - Public Methods (View가 호출할 함수)
            
        /// 상품을 구매합니다.
        func purchaseKanchuMonthlyProduct() {
            logger.info("월간 상품 구매를 시작합니다.") // 구매 시작 로깅
            isLoading = true
            defer { isLoading = false }

            Task {
                do {
                    try await purchaseKanchuMonthlyProductUseCase.execute()
                    // 구매 성공 시, 상태를 즉시 갱신합니다.
                    await updateSubscriptionStatus()
                    logger.info("월간 상품 구매 성공.") // 구매 성공 로깅
                } catch {
                    logger.error("월간 상품 구매 실패: \(error.localizedDescription, privacy: .public)") // 구매 실패 로깅
                    self.error = error
                }
            }
        }
        
        /// 구매 내역을 복원합니다.
        func restorePurchases() {
            logger.info("구매 내역 복원을 시작합니다.") // 복원 시작 로깅
            isLoading = true
            defer { isLoading = false }
            
            Task {
                await restorePurchasesUseCase.execute()
                logger.info("구매 내역 복원 완료 (세부 결과는 유즈케이스 내에서 처리될 수 있습니다).") // 복원 완료 로깅
            }
        }
        
        // MARK: - Private Helper Methods
        
        /// 현재 구독 상태를 확인하여 `status` 상태를 업데이트합니다.
        private func updateSubscriptionStatus() async {
            logger.debug("현재 구독 상태를 확인합니다.") // 상태 업데이트 시작 로깅
            let newStatus = await checkSubscriptionStatusUseCase.execute()
            self.status = newStatus
            logger.info("구독 상태가 '\(newStatus.description())'(으)로 업데이트되었습니다.") // 상태 업데이트 결과 로깅
        }
        
        /// 백그라운드에서 발생하는 거래를 감시하고, 변경이 생기면 상태를 갱신합니다.
        private func observeTransactions() {
            logger.info("거래 관찰을 시작합니다.") // 거래 관찰 시작 로깅
            self.transactionObserver = Task {
                for await _ in observeTransactionsUseCase.execute() {
                    // 외부에서 거래 변경이 감지되면(갱신, 환불 등)
                    // 사용자의 현재 상태를 다시 확인합니다.
                    logger.info("새로운 거래 변경이 감지되었습니다. 구독 상태를 갱신합니다.") // 거래 감지 로깅
                    await updateSubscriptionStatus()
                }
                logger.info("거래 관찰이 종료되었습니다.") // 관찰 종료 로깅 (Task가 취소될 경우)
            }
        }
    }
}

