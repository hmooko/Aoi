//
//  Grade.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/28/24.
//

import Foundation

enum Grade: String, Hashable {
    case first = "초등학교1학년", second = "초등학교2학년", third = "초등학교3학년", forth = "초등학교4학년", fifth = "초등학교5학년", sixth = "초등학교6학년"
    case elementary = "초등학교"    
    case middle = "중학교"
    
    static func elementarySchoolCases() -> [Grade] {
        [.first, .second, .third, .forth, .fifth, .sixth]
    }
    
    static func allCases() -> [Grade] {
        [.first, .second, .third, .forth, .fifth, .sixth, .middle]
    }
    
    static func gradeCount(_ grade: Grade) -> Int {
        switch grade {
        case .first: return 80
        case .second: return 160
        case .third: return 200
        case .forth: return 202
        case .fifth: return 193
        case .sixth: return 191
        case .elementary: return 1026
        case .middle: return 1110
        }
    }
}
