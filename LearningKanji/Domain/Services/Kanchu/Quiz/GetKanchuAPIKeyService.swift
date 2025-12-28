//
//  GetGeminiAPIKeyService.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/18/25.
//

import Foundation

protocol GetKanchuAPIKeyUseCase {
    func execute() -> String
}

final class GetKanchuAPIKeyService: GetKanchuAPIKeyUseCase {
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func execute() -> String {
        userDefaultsRepository.getKanchuAPIKey()
    }
}

// MARK: - Mock Service
final class MockGetKanchuAPIKeyService: GetKanchuAPIKeyUseCase {
    var apiKey: String = "MOCK_API_KEY"
    
    func execute() -> String {
        return apiKey
    }
}
