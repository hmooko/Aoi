//
//  QuizTarget.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation

/**
 학습 대상을 나타내는 모델입니다. 학년 또는 북마크 그룹을 포함할 수 있습니다.

 - `elementary`: 초등학교 학년
 - `middleSchool`: 중학교 학년 (인덱스)
 - `bookmark`: 사용자가 지정한 북마크 그룹
 */
enum QuizTarget: Hashable {
    /// 초등학교 학년
    case elementary(grade: Grade)
    /// 중학교 학년 (인덱스)
    case middleSchool(index: Int)
    /// 북마크 그룹 (id와 이름 포함)
    case bookmark(id: Int, name: String) // 북마크 그룹
    
    /**
     학습 대상의 문자열 표현을 반환합니다.

     - Returns: 대상의 문자열 이름
     */
    func getString() -> String {
        switch self {
        case .elementary(grade: let grade):
            switch grade {
            case .first:
                return "초1"
            case .second:
                return "초2"
            case .third:
                return "초3"
            case .forth:
                return "초4"
            case .fifth:
                return "초5"
            case .sixth:
                return "초6"
            case .elementary:
                return "초등학교"
            case .middle:
                return "중학교"
            }
        case .middleSchool(index: let index):
            return "중\(index)"
        case .bookmark(id: _, name: let name):
            return name
        }
    }
}
