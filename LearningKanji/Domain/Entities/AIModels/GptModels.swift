//
//  GptModels.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/17/25.
//

import Foundation

enum GptModel: AIModel {
    case gpt5
    
    var provider: String {
        return "Open AI"
    }
    
    var rawValue: String {
        switch self {
        case .gpt5:
            return "gpt-5-medium"
        }
    }
}
