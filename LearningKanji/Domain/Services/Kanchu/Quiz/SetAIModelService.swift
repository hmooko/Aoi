//
//  SetAIModelService.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/17/25.
//

import Foundation

protocol SetAIModelUseCase {
    func execute(model: any AIModel)
}

final class SetAIModelService: SetAIModelUseCase {
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func execute(model: any AIModel) {
        userDefaultsRepository.setAIModel(model)
    }
}

// MARK: - Mock Service
final class MockSetAIModelService: SetAIModelUseCase {
    var receivedModel: (any AIModel)?
    
    func execute(model: any AIModel) {
        self.receivedModel = model
    }
}
