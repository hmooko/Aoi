//
//  DefaultSubscriptionRepository.swift
//  LearningKanji
//
//  Minimal StoreKit 2 subscription repository with a single monthly product.
//

import Foundation
import StoreKit

/// 구독 관련 작업에서 발생할 수 있는 에러를 정의합니다.
enum SubscriptionError: Error, LocalizedError {
    case productNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .productNotFound(let id):
            return "ID(\(id))에 해당하는 상품을 찾을 수 없습니다."
        }
    }
}


/// 도메인 계층에 정의된 Repository의 요구사항(프로토콜)을 구현하는 구체적인 클래스
@MainActor
final class DefaultSubscriptionRepository: SubscriptionRepository {

    // MARK: - Product Management

    /// App Store Connect에 등록된 모든 상품 정보를 가져옵니다.
    /// - Returns: StoreKit의 `Product` 객체 배열
    func fetchProducts() async throws -> [SubscriptionProduct] {
        // App Store Connect 또는 StoreKit Configuration 파일에 정의된 Product ID 목록
        let productIDs = ProductIDs.allCases()
        
        do {
            // StoreKit에게 ID 목록에 해당하는 상품 정보를 비동기적으로 요청합니다.
            return try await Product.products(for: productIDs.map { $0.rawValue }).map { product in
                SubscriptionProduct(
                    id: product.id,
                    displayName: product.displayName,
                    displayPrice: product.displayPrice,
                    description: product.description,
                    underlyingProduct: product
                )
            }
        } catch {
            // 상품 정보를 가져오는데 실패하면 에러를 던집니다.
            print("StoreKit 제품 정보를 가져오는데 실패했습니다: \(error)")
            throw error
        }
    }
    
    func fetchProduct(productID: ProductIDs) async throws -> SubscriptionProduct {
        do {
            let products = try await Product.products(for: [productID.rawValue]).map { product in
                SubscriptionProduct(
                    id: product.id,
                    displayName: product.displayName,
                    displayPrice: product.displayPrice,
                    description: product.description,
                    underlyingProduct: product
                )
            }
            
            guard let product = products.first else {
                throw SubscriptionError.productNotFound(productID.rawValue)
            }
            
            return product
        } catch {
            // 상품 정보를 가져오는데 실패하면 에러를 던집니다.
            print("StoreKit 제품 정보를 가져오는데 실패했습니다: \(error)")
            throw error
        }
    }

    // MARK: - Purchase Management

    /// 특정 상품의 구매를 시작합니다.
    /// - Parameter product: 사용자가 구매하려는 StoreKit의 `Product` 객체
    func purchase(_ product: SubscriptionProduct) async throws {
        guard let product = product.underlyingProduct as? Product else {
            // 실제 Product가 없는 잘못된 모델인 경우 에러 처리
            throw URLError(.badURL) // 혹은 적절한 커스텀 에러
        }
        
        // product.purchase()를 호출하여 시스템 구매창을 띄웁니다.
        let result = try await product.purchase()

        // 구매 결과를 처리합니다.
        switch result {
        case .success(let verification):
            // 구매가 성공하고 Apple 서버로부터 서명된 트랜잭션을 받으면,
            // 이 트랜잭션이 유효한지 검증합니다.
            let transaction = try self.verify(verification)
            
            // 검증이 완료된 트랜잭션은 앱에서 모든 처리가 끝났음을 StoreKit에 알립니다.
            // 이 과정을 거치지 않으면 동일한 트랜잭션이 계속해서 전달될 수 있습니다.
            await transaction.finish()
            
            // 구매 성공 후에는 특별히 반환할 값 없이 종료합니다.
            // 상태 업데이트는 ViewModel이 담당합니다.
            
        case .userCancelled:
            // 사용자가 구매 창을 닫은 경우로, 특별한 처리는 필요 없습니다.
            // ViewModel에서 이 경우를 에러로 간주하지 않도록 처리할 수 있습니다.
            break
            
        case .pending:
            // '가족 승인 요청' 등 구매가 보류 중인 상태입니다.
            // 이 역시 앱에서 별도의 처리는 필요 없으며, 나중에 Transaction.updates를 통해 결과가 전달됩니다.
            break
            
        @unknown default:
            // 향후 추가될 수 있는 새로운 케이스에 대한 처리입니다.
            break
        }
    }

    /// 사용자가 수동으로 구매 내역을 복원하도록 요청할 때 사용됩니다.
    func restorePurchases() async {
        // App Store에 앱의 영수증을 동기화하여 최신 거래 내역을 가져오도록 요청합니다.
        // 결과는 Transaction.updates를 통해 비동기적으로 전달됩니다.
        try? await AppStore.sync()
    }

    // MARK: - Transaction Management

    /// 앱 외부에서 발생하는 모든 거래(구독 갱신, 환불, 프로모션 코드 사용 등)를 감시합니다.
    /// - Returns: 거래가 발생할 때마다 Void 이벤트를 방출하는 AsyncStream
    func observeTransactionUpdates() -> AsyncStream<Void> {
        AsyncStream { continuation in
            let task = Task.detached {
                // Transaction.updates는 AsyncSequence이므로 for-await-in 루프로 계속해서 감시할 수 있습니다.
                for await result in Transaction.updates {
                    do {
                        let transaction = try await self.verify(result)
                        
                        // 유효한 거래가 감지되면, ViewModel에게 상태를 갱신하라고 신호를 보냅니다.
                        continuation.yield(())
                        
                        // 이 트랜잭션도 처리가 완료되었음을 알립니다.
                        await transaction.finish()
                    } catch {
                        print("🚨 트랜잭션 검증에 실패했습니다: \(error)")
                    }
                }
            }
            
            // 스트림이 종료될 때 감시하던 Task도 함께 종료시킵니다.
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }

    /// 현재 사용자가 보유한 모든 유효한 구독(Entitlements)을 가져옵니다.
    /// 앱 시작 시 사용자의 구독 상태를 확인하는 데 주로 사용됩니다.
    /// - Returns: 유효성이 검증된 `Transaction` 객체 배열
    func fetchCurrentEntitlements() async -> [Transaction] {
        var validTransactions: [Transaction] = []
        
        // Transaction.currentEntitlements는 현재 사용자가 접근 권한을 가진 모든 상품의 트랜잭션을 포함합니다.
        for await result in Transaction.currentEntitlements {
            if let transaction = try? self.verify(result) {
                validTransactions.append(transaction)
            }
        }
        
        return validTransactions
    }

    // MARK: - Private Helpers

    /// Apple로부터 받은 트랜잭션이 변조되지 않았는지 검증합니다. (JWS 서명 확인)
    private func verify<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            // 서명이 유효하지 않은 경우. 해킹 시도일 수 있으므로 에러 처리합니다.
            throw URLError(.badServerResponse) // 혹은 적절한 커스텀 에러
        case .verified(let safe):
            // 서명이 유효한 경우, 안전한 원본 데이터를 반환합니다.
            return safe
        }
    }
}
