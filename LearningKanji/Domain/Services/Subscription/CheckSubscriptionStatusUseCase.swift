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
        
        // StoreKit은 각 구독 그룹에 대해 가장 높은 등급의 활성 구독 트랜잭션 하나만 반환합니다.
        // 따라서 첫 번째로 발견되는 유효한 트랜잭션을 사용자의 현재 구독 상태로 간주할 수 있습니다.
        for transaction in transactions {
            // 1. 트랜잭션이 유효한지(환불되거나 업그레이드되지 않았는지) 확인합니다.
            guard transaction.revocationDate == nil, !transaction.isUpgraded else {
                continue
            }
            
            // 2. 트랜잭션의 Product ID를 기반으로 구독 상태를 결정합니다.
            let status: SubscriptionStatus
            switch transaction.productID {
            case ProductIDs.kanchuMonthly.rawValue:
                status = .paidKanchuMonthly
            // case ProductIDs.kanchuYearly.rawValue: // 예시: 추후 연간 구독 추가 시
            //     status = .paidKanchuYearly
            default:
                // 우리가 관리하는 Product ID가 아니면 건너뜁니다.
                continue
            }
            
            // 3. 자동 갱신 구독이며, 만료되지 않았는지 확인합니다.
            if transaction.productType == .autoRenewable,
               let expirationDate = transaction.expirationDate,
               expirationDate > Date() {
                // 유효한 활성 구독을 찾았으므로 즉시 상태를 반환합니다.
                return status
            }
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
