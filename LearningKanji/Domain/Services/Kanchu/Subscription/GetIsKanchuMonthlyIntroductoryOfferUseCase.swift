//
//  GetIsIntroductoryOffer.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/23/25.
//

import Foundation

protocol GetIsKanchuMonthlyIntroductoryOfferUseCase {
    func excute() async throws -> Bool
}

final class GetIsKanchuMonthlyIntroductoryOfferService: GetIsKanchuMonthlyIntroductoryOfferUseCase {
    private let subscriptionRepository: SubscriptionRepository
    
    init(subscriptionRepository: SubscriptionRepository) {
        self.subscriptionRepository = subscriptionRepository
    }
    
    func excute() async throws -> Bool {
        return try await subscriptionRepository.getIsIntroductoryOffer(productID: .kanchuMonthly)
    }
}

final class MockGetIsKanchuMonthlyIntroductoryOfferUseCase: GetIsKanchuMonthlyIntroductoryOfferUseCase {
    var isEligible: Bool = false
    var error: Error?

    func excute() async throws -> Bool {
        if let error = error {
            throw error
        }
        return isEligible
    }
}
