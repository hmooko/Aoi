//
//  SetGeminiAPIKeyService.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/18/25.
//

import Foundation

protocol SetKanchuAPIKeyUseCase {
    func execute(key: String)
}

final class SetKanchuAPIKeyService: SetKanchuAPIKeyUseCase {
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func execute(key: String) {
        userDefaultsRepository.setKanchuAPIKey(key)
    }
}

// MARK: - Mock Service
final class MockSetKanchuAPIKeyService: SetKanchuAPIKeyUseCase {
    var receivedKey: String?
    
    func execute(key: String) {
        self.receivedKey = key
    }
}
