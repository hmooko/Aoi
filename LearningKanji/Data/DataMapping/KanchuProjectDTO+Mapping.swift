//
//  KanchuProjectDTO.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/25.
//

import Foundation
import SwiftData

@Model
final class KanchuProjectDTO {
    /// 프로젝트의 고유 식별자
    var id: UUID = UUID()
    
    /// 프로젝트 이름 (예: "초1 - 올바른 발음 구하기")
    var name: String = ""
    
    /// 프로젝트 생성 일자
    var createdAt: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \KanchuProblemDTO.project)
    var questions: [KanchuProblemDTO]? = []
    
    // 프로젝트 고정 여부
    var isPinned: Bool = false
    
    init(id: UUID, name: String, createdAt: Date, questions: [KanchuProblemDTO], isPinned: Bool) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.questions = questions
        self.isPinned = isPinned
    }
}

extension KanchuProjectDTO {
    func toDomain() -> KanchuProject {
        guard let questions else {
            return .init(id: self.id, name: self.name, createdAt: self.createdAt, questions: [], isPinned: self.isPinned)
        }
        let problems: [KanchuProblem] = questions.map { $0.toDomain() }
        return .init(id: self.id, name: self.name, createdAt: self.createdAt, questions: problems, isPinned: self.isPinned)
    }
}

extension KanchuProject {
    func toDTO() -> KanchuProjectDTO {
        // 1. questions 없이 ProjectDTO를 먼저 생성하여 재귀 호출을 방지합니다.
        let projectDTO = KanchuProjectDTO(
            id: self.id,
            name: self.name,
            createdAt: self.createdAt,
            questions: [], // 우선 빈 배열로 초기화
            isPinned: self.isPinned
        )
        
        // 2. 생성된 projectDTO를 참조하여 ProblemDTO들을 생성합니다.
        let problemDTOs = self.questions.map { $0.toDTO(project: projectDTO) }
        
        // 3. 완성된 ProblemDTO 배열을 projectDTO에 할당합니다.
        projectDTO.questions = problemDTOs
        
        return projectDTO
    }
}
