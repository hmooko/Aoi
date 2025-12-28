//
//  FetchKanchuProductsUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import Foundation

protocol FetchProductsUseCase {
    /// 유즈케이스를 실행합니다.
    /// - Returns: 도메인 모델인 `SubscriptionProduct`의 배열
    func execute() async throws -> [SubscriptionProduct]
}

/// 사용 가능한 구독 상품 목록을 가져오는 비즈니스 로직입니다.
final class FetchProductsService: FetchProductsUseCase {
    private let subscriptionRepository: SubscriptionRepository

    init(subscriptionRepository: SubscriptionRepository) {
        self.subscriptionRepository = subscriptionRepository
    }

    func execute() async throws -> [SubscriptionProduct] {
        return try await subscriptionRepository.fetchProducts()
    }
}

// MARK: - Mock for Preview/Testing
final class MockFetchKanchuProductsUseCase: FetchProductsUseCase {
    var mockProducts: [SubscriptionProduct]
    var shouldThrowError: Bool

    init(mockProducts: [SubscriptionProduct] = [], shouldThrowError: Bool = false) {
        self.mockProducts = mockProducts
        if mockProducts.isEmpty {
            self.mockProducts = [
                SubscriptionProduct(id: "com.yourapp.kanchu.monthly", displayName: "Kanchu 월간 프로", displayPrice: "₩5,900", description: "한 달 동안 모든 기능을 사용해보세요.", underlyingProduct: "mock_monthly"),
                SubscriptionProduct(id: "com.yourapp.kanchu.yearly", displayName: "Kanchu 연간 프로", displayPrice: "₩35,000", description: "일 년 동안 모든 기능을 사용해보세요.", underlyingProduct: "mock_yearly")
            ]
        }
        self.shouldThrowError = shouldThrowError
    }

    func execute() async throws -> [SubscriptionProduct] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "테스트를 위해 제품을 가져오는 데 실패했습니다."])
        }
        // 실제 UseCase와 동일하게 "Kanchu"가 포함된 상품만 반환하도록 필터링합니다.
        return mockProducts.filter { $0.displayName.contains("Kanchu") }
    }
}
