//
//  RestorePurchaseUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import Foundation

protocol RestorePurchasesUseCase {
    /// 유즈케이스를 실행합니다.
    func execute() async
}

/// 구매 내역을 복원하는 비즈니스 로직입니다.
final class RestorePurchasesService: RestorePurchasesUseCase {
    private let subscriptionRepository: SubscriptionRepository
    
    init(subscriptionRepository: SubscriptionRepository) {
        self.subscriptionRepository = subscriptionRepository
    }
    
    func execute() async {
        await subscriptionRepository.restorePurchases()
    }
}

// MARK: - Mock for Preview/Testing
final class MockRestorePurchasesUseCase: RestorePurchasesUseCase {
    func execute() async {
        // Mock implementation
        print("Mock: Restore purchases called.")
    }
}
