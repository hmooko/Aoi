//
//  CheckSubscriptionStatusUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import Foundation
import StoreKit

protocol CheckSubscriptionStatusUseCase {
    /// 유즈케이스를 실행합니다.
    /// - Returns: `SubscriptionStatus`
    func execute() async -> SubscriptionStatus
}

/// 현재 사용자의 구독 상태를 확인하는 비즈니스 로직입니다.
final class CheckSubscriptionStatusService: CheckSubscriptionStatusUseCase {
    private let subscriptionRepository: SubscriptionRepository
    
    init(subscriptionRepository: SubscriptionRepository) {
        self.subscriptionRepository = subscriptionRepository
    }

    func execute() async -> SubscriptionStatus {
        let transactions = await subscriptionRepository.fetchCurrentEntitlements()
        
        // 유효한 트랜잭션이 하나만 있다고 가정하고, 가장 먼저 발견되는 유효한 구독 상태를 반환합니다.
        for transaction in transactions {
            // 1. 트랜잭션의 Product ID를 기반으로 잠재적인 SubscriptionStatus를 결정합니다.
            let potentialStatus: SubscriptionStatus? = {
                if transaction.productID == ProductIDs.kanchuMonthly.rawValue {
                    return .paidKanchuMonthly
                }
                return nil // 우리가 정의한 유료 구독 상품이 아님
            }()
            
            guard let status = potentialStatus else {
                continue // 이 트랜잭션은 우리가 관심 있는 구독 상품과 관련이 없습니다.
            }
            
            // 2. 트랜잭션이 환불되지 않았고 (revocationDate == nil), 다른 구독으로 업그레이드되지 않았는지 (isUpgraded == false) 확인합니다.
            guard transaction.revocationDate == nil && !transaction.isUpgraded else {
                continue // 유효하지 않은 트랜잭션 (환불 또는 업그레이드로 인한 무효화)
            }
            
            // 3. 해당 트랜잭션이 자동 갱신 구독이며, 현재 활성 상태인지 확인합니다.
            // `productType`이 `.autoRenewable`이고, `expirationDate`가 현재 날짜보다 미래인 경우 활성 구독으로 간주합니다.
            if transaction.productType == .autoRenewable {
                if let expirationDate = transaction.expirationDate, expirationDate > Date() {
                    // 유효한 구독을 찾았으므로 즉시 해당 상태를 반환합니다.
                    return status
                }
            }
            // 이 트랜잭션은 자동 갱신 구독이 아니거나, 이미 만료되었습니다.
        }
        
        // 모든 트랜잭션을 확인했지만 유효한 구독을 찾지 못했습니다.
        return .free
    }
}

// MARK: - Mock for Preview/Testing
final class MockCheckSubscriptionStatusUseCase: CheckSubscriptionStatusUseCase {
    var mockStatus: SubscriptionStatus

    init(mockStatus: SubscriptionStatus = .free) {
        self.mockStatus = mockStatus
    }

    func execute() async -> SubscriptionStatus {
        return mockStatus
    }
}
