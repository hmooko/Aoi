//
//  KanchuProject.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/22/25.
//

import Foundation

/// 하나의 문제집 프로젝트를 나타내는 구조체입니다.
struct KanchuProject: Identifiable, Codable, Hashable {
    /// 프로젝트의 고유 식별자
    let id: UUID
    
    /// 프로젝트 이름 (예: "초1 - 올바른 발음 구하기")
    let name: String
    
    /// 프로젝트 생성 일자
    let createdAt: Date
    
    /// 프로젝트에 포함된 실제 문제들의 배열
    let questions: [KanchuProblem]
    
    /// 프로젝트 고정 여부
    let isPinned: Bool
}


// MARK: - Example Usage
// 아래는 KanchuProject를 생성하는 예시입니다.

func createExampleProject() -> KanchuProject {
    // 예시 문제 데이터 생성
    let exampleProblems: [KanchuProblem] = [
        .init(id: UUID(), type: .findReading, sentence: "これは(複雑)な問題です。", targetKanji: "複雑", options: ["ふくざつ", "ふくさつ", "ふうざつ"], answer: "ふくざつ", targetWord: "複雑"),
        .init(id: UUID(), type: .findReading, sentence: "面白い(話)を聞きました。", targetKanji: "話", options: ["はなし", "こと", "わ"], answer: "はなし", targetWord: "話"),
        .init(id: UUID(), type: .findReading, sentence: "毎朝、公園を(散歩)します。", targetKanji: "散歩", options: ["さんぽ", "さんぶ", "さんぽう"], answer: "さんぽ", targetWord: "散歩")
    ]
    
    // 생성된 문제들로 프로젝트를 만듭니다.
    let newProject = KanchuProject(
        id: UUID(),
        name: "초1 - 올바른 발음 구하기",
        createdAt: Date(),
        questions: exampleProblems,
        isPinned: false
    )
    
    print("새로운 문제집이 생성되었습니다: \(newProject.name)")
    return newProject
}

func createExampleProjects() -> [KanchuProject] {
    var projects: [KanchuProject] = [createExampleProject()]

    // Project 2: 한자 찾기 연습
    let project2Problems: [KanchuProblem] = [
        .init(id: UUID(), type: .findKanji, sentence: "きょう(はな)を買いました。", targetKanji: "花", options: ["花", "草", "木", "米"], answer: "花", targetWord: "はな"),
        .init(id: UUID(), type: .findKanji, sentence: "(みず)を飲みます。", targetKanji: "水", options: ["水", "火", "木", "金"], answer: "水", targetWord: "みず"),
        .init(id: UUID(), type: .findKanji, sentence: "(ひ)を消してください。", targetKanji: "火", options: ["水", "火", "風", "土"], answer: "火", targetWord: "ひ")
    ]
    let project2 = KanchuProject(
        id: UUID(),
        name: "초1 - 한자 찾기 연습",
        createdAt: Date().addingTimeInterval(-86400), // 하루 전
        questions: project2Problems,
        isPinned: true
    )
    projects.append(project2)
    print("추가 문제집 생성됨: \(project2.name)")

    // Project 3: 빈칸 채우기 챌린지
    let project3Problems: [KanchuProblem] = [
        .init(id: UUID(), type: .fillReading, sentence: "私は本を(＿＿＿)。", targetKanji: "読", options: ["よみます", "とみます", "どくます"], answer: "よみます", targetWord: "読みます"),
        .init(id: UUID(), type: .fillReading, sentence: "朝ご飯を(＿＿＿)。", targetKanji: "食", options: ["たべます", "しょくます", "たべる"], answer: "たべます", targetWord: "食べます"),
        .init(id: UUID(), type: .fillReading, sentence: "毎日水を(＿＿＿)。", targetKanji: "飲", options: ["のみます", "미즈마스", "のみ루"], answer: "のみます", targetWord: "飲みます")
    ]
    let project3 = KanchuProject(
        id: UUID(),
        name: "초2 - 빈칸 채우기 챌린지",
        createdAt: Date().addingTimeInterval(-172800), // 이틀 전
        questions: project3Problems,
        isPinned: false
    )
    projects.append(project3)
    print("추가 문제집 생성됨: \(project3.name)")

    return projects
}
