//
//  AIModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/17/25.
//

protocol AIModel: CaseIterable {
    var provider: String { get }
    /// 모델의 고유한 문자열 값입니다. (예: "gemini-2.5-pro")
    var rawValue: String { get }
}
