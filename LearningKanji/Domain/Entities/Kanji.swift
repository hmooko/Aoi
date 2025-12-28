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
    
    static var sampleKanji1 =
        Kanji(
            id: 0,
            kanji: "家",
            grade: "초등학교2학년",
            sound: "か、け",
            meaning: "無し",
            korean: "집 가"
        )
    
    static var sampleKanjiList = [
        Kanji(id: 1, kanji: "学", grade: "초등학교1학년", sound: "がく、まなぶ", meaning: "まなぶ", korean: "배울 학"),
        Kanji(id: 2, kanji: "校", grade: "초등학교1학년", sound: "こう", meaning: "無し", korean: "학교 교"),
        Kanji(id: 3, kanji: "友", grade: "초등학교2학년", sound: "とも", meaning: "ともだち", korean: "벗 우"),
        Kanji(id: 4, kanji: "歌", grade: "초등학교2학년", sound: "か", meaning: "うた、うたう", korean: "노래 가"),
        Kanji(id: 5, kanji: "森", grade: "초등학교3학년", sound: "もり", meaning: "もり", korean: "숲 삼"),
        Kanji(id: 6, kanji: "雪", grade: "초등학교3학년", sound: "せつ", meaning: "ゆき", korean: "눈 설"),
        Kanji(id: 7, kanji: "湖", grade: "초등학교4학년", sound: "こ", meaning: "みずうみ", korean: "호수 호"),
        Kanji(id: 8, kanji: "試", grade: "초등학교4학년", sound: "し", meaning: "こころみる、ためす", korean: "시험 시"),
        Kanji(id: 9, kanji: "覚", grade: "초등학교5학년", sound: "かく", meaning: "おぼえる", korean: "깨달을 각"),
        Kanji(id: 10, kanji: "優", grade: "초등학교5학년", sound: "ゆう", meaning: "やさしい、すぐれる", korean: "넉넉할 우"),
        Kanji(id: 11, kanji: "億", grade: "초등학교6학년", sound: "おく", meaning: "無し", korean: "억 억"),
        Kanji(id: 12, kanji: "熟", grade: "초등학교6학년", sound: "じゅく", meaning: "うれる", korean: "익을 숙"),
        Kanji(id: 13, kanji: "徒", grade: "중학교", sound: "と", meaning: "없음", korean: "무리 도"),
        Kanji(id: 14, kanji: "携", grade: "중학교", sound: "けい", meaning: "たずさえる", korean: "이끌 휴")
    ]
}
