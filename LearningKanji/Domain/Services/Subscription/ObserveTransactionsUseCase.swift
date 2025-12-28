//
//  ObserveTransactionsUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import Foundation

@MainActor
protocol ObserveTransactionsUseCase {
    /// 유즈케이스를 실행합니다.
    /// - Returns: 거래가 발생할 때마다 이벤트를 방출하는 스트림
    func execute() -> AsyncStream<Void>
}

@MainActor
/// 백그라운드 트랜잭션 업데이트를 감시하는 비즈니스 로직입니다.
final class ObserveTransactionsService: ObserveTransactionsUseCase {
    private let subscriptionRepository: SubscriptionRepository

    init(subscriptionRepository: SubscriptionRepository) {
        self.subscriptionRepository = subscriptionRepository
    }

    func execute() -> AsyncStream<Void> {
        return subscriptionRepository.observeTransactionUpdates()
    }
}

// MARK: - Mock for Preview/Testing
@MainActor
final class MockObserveTransactionsUseCase: ObserveTransactionsUseCase {
    private var continuation: AsyncStream<Void>.Continuation?
    private let stream: AsyncStream<Void>

    init() {
        var capturedContinuation: AsyncStream<Void>.Continuation?
        self.stream = AsyncStream { continuation in
            capturedContinuation = continuation
        }
        self.continuation = capturedContinuation
    }

    func execute() -> AsyncStream<Void> {
        return stream
    }

    /// 테스트를 위해 모의 거래 업데이트를 트리거합니다.
    func triggerUpdate() {
        continuation?.yield(())
    }
    
    /// 스트림을 종료합니다.
    func finish() {
        continuation?.finish()
    }
}
