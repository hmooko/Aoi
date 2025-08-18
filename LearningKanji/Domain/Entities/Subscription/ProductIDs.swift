//
//  ProductIDs.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

enum ProductIDs: String {
    case kanchuMonthly = "com.koo.LearningKanji.Kanchu.monthly"
    
    static func allCases() -> [ProductIDs] {
        [.kanchuMonthly]
    }
}
