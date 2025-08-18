//
//  PurchaseKanchuUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import StoreKit

protocol PurchaseKanchuMonthlyProductUseCase {
    /// 유즈케이스를 실행합니다.
    /// - Parameter product: 구매할 `SubscriptionProduct` 도메인 모델
    func execute() async throws
}

/// 특정 상품을 구매하는 비즈니스 로직입니다.
final class PurchaseKanchuMonthlyProductService: PurchaseKanchuMonthlyProductUseCase {
    private let subscriptionRepository: SubscriptionRepository

    init(subscriptionRepository: SubscriptionRepository) {
        self.subscriptionRepository = subscriptionRepository
    }

    func execute() async throws {
        // 도메인 모델에 저장된 실제 Product 객체를 꺼내 Repository에 전달합니다.
        let storeKitProduct = try await subscriptionRepository.fetchProduct(productID: .kanchuMonthly)
        
        try await subscriptionRepository.purchase(storeKitProduct)
    }
}

// MARK: - Mock for Preview/Testing
final class MockPurchaseKanchuUseCase: PurchaseKanchuMonthlyProductUseCase {
    func execute() async throws {
        print("Mock: Attempting to purchase product")
    }
}
