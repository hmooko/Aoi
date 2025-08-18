//
//  SubscriptionRepository.swift
//  LearningKanji
//
//  Defines a minimal interface for StoreKit 2 subscription operations.
//

import Foundation

@MainActor
protocol SubscriptionRepository {
    func isEntitled() async -> Bool
    func purchaseMonthly() async throws
    func restorePurchases() async
}

