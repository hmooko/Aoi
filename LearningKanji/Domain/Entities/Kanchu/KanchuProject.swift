//
//  KanchuProject.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/22/25.
//

import Foundation

/// 하나의 문제집 프로젝트를 나타내는 구조체입니다.
struct KanchuProject: Identifiable, Codable {
    /// 프로젝트의 고유 식별자
    let id: UUID
    
    /// 프로젝트 이름 (예: "초1 - 올바른 발음 구하기")
    let name: String
    
    /// 프로젝트 생성 일자
    let createdAt: Date
    
    /// 프로젝트에 포함된 문제의 총 개수
    let questionCount: Int
    
    /// 프로젝트에 포함된 실제 문제들의 배열
    let questions: [KanchuProblem]
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
        questionCount: exampleProblems.count,
        questions: exampleProblems
    )
    
    print("새로운 문제집이 생성되었습니다: \(newProject.name)")
    return newProject
}
