//
//  GeminiModels.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/17/25.
//

import Foundation

enum GeminiModel: AIModel {
    case gemini2_5Flash
    case gemini2_5Pro
    
    var provider: String {
        return "Google"
    }
    
    var rawValue: String {
        switch self {
        case .gemini2_5Flash: return "gemini-2.5-flash"
        case .gemini2_5Pro: return "gemini-2.5-pro"
        }
    }
}
