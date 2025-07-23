//
//  ProblemType.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/**
 퀴즈 문제의 유형을 정의합니다.

 - `findReading`: 올바른 발음 구하기 문제 유형
 - `findKanji`: 올바른 한자 표기 구하기 문제 유형
 - `fillReading`: 발음에 해당하는 한자 표기 구하기 문제 유형
 */
// Codable을 지원하여 KanchuProblem, KanchuProject 등에서 안전하게 사용 가능함
enum ProblemType: String, CaseIterable, Codable {
    /// 올바른 발음 구하기
    case findReading = "올바른 발음 구하기"
    /// 올바른 한자 표기 구하기
    case findKanji = "올바른 한자 표기 구하기"
    /// 발음에 해당하는 한자 표기 구하기
    case fillReading = "발음에 해당하는 한자 표기 구하기"
}

