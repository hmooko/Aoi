//
//  Kanji.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/10/24.
//

import Foundation

struct Kanji: Identifiable, Equatable, Decodable, Hashable {
    let id: Int
    let kanji: String
    let grade: String
    let sound: String
    let meaning: String
    let korean: String
    
    static func == (lhs: Kanji, rhs: Kanji) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getGradeAtPlain() -> String {
        if grade.contains("초등학교") == false { return "中" }
        
        return "小\(grade[grade.index(grade.startIndex, offsetBy: 3)])"
    }
    
    static var sampleKanji =
        Kanji(
            id: 0,
            kanji: "家",
            grade: "초등학교2학년",
            sound: "か、け",
            meaning: "いえ、や",
            korean: "집 가"
        )
    
    static var sampleKanjiList = [
        Kanji(
            id: 1,
            kanji: "歌",
            grade: "초등학교2학년",
            sound: "か",
            meaning: "うた、うたう",
            korean: "노래 가"
        ),
        Kanji(
            id: 2,
            kanji: "加",
            grade: "초등학교4학년",
            sound: "か",
            meaning: "くわえる、くわわる",
            korean: "더할 가"
        ),
        Kanji(
            id: 3,
            kanji: "街",
            grade: "초등학교4학년",
            sound: "がい、かい",
            meaning: "まち",
            korean: "거리 가"
        ),
        Kanji(
            id: 4,
            kanji: "可",
            grade: "초등학교5학년",
            sound: "か",
            meaning: "無し",
            korean: "옳을 가"
        )
    ]
}
