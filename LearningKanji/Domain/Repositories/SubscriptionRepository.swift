//
//  SubscriptionRepository.swift
//  LearningKanji
//
//  Defines a minimal interface for StoreKit 2 subscription operations.
//

import Foundation
import StoreKit

@MainActor
/// 도메인 계층이 데이터 계층과 소통하기 위한 창구(Port) 역할을 하는 프로토콜입니다.
protocol SubscriptionRepository {
    
    /// 판매 가능한 모든 상품 정보를 가져옵니다.
    func fetchProducts() async throws -> [SubscriptionProduct]
    
    /// 특정 상품 정보를 가져옵니다.
    func fetchProduct(productID: ProductIDs) async throws -> SubscriptionProduct
    
    /// 특정 상품의 구매를 시작합니다.
    func purchase(_ product: SubscriptionProduct) async throws
    
    /// 구매 내역을 수동으로 복원(동기화)합니다.
    func restorePurchases() async
    
    /// 백그라운드에서 발생하는 거래(갱신, 환불 등)를 감시합니다.
    func observeTransactionUpdates() -> AsyncStream<Void>
    
    /// 현재 사용자가 보유한 모든 유효한 구독 권한을 가져옵니다.
    func fetchCurrentEntitlements() async -> [Transaction]
}

