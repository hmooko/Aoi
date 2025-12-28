//
//  GetAIModelService.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/18/25.
//

import Foundation

protocol GetAIModelUseCase {
    func execute() throws -> AIModel
}

final class GetAIModelService: GetAIModelUseCase {
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func execute() throws -> AIModel {
        try userDefaultsRepository.getAIModel()
    }
}

// MARK: - Mock Service
final class MockGetAIModelService: GetAIModelUseCase {
    
    var modelToReturn: AIModel = GeminiModel.gemini2_5Flash
    var errorToThrow: Error?
    
    func execute() throws -> AIModel {
        if let error = errorToThrow {
            throw error
        }
        return modelToReturn
    }
}
