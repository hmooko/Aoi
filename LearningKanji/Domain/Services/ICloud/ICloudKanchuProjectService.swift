//
//  ICloudKanchuProjectService.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/19/25.
//

import Foundation

protocol ICloudKanchuProjectUseCase {
    func backup() async throws
    func load() async throws
}

final class ICloudKanchuProjectService: ICloudKanchuProjectUseCase {

    private let kanchuProjectRepository: KanchuProjectRepository
    private let cloudKitKanchuProjectRepository: CloudKitKanchuProjectRepository

    init(
        kanchuProjectRepository: KanchuProjectRepository,
        cloudKitKanchuProjectRepository: CloudKitKanchuProjectRepository
    ) {
        self.kanchuProjectRepository = kanchuProjectRepository
        self.cloudKitKanchuProjectRepository = cloudKitKanchuProjectRepository
    }

    func backup() async throws {
        // 1단계: CloudKit의 모든 기존 프로젝트 삭제
        try await cloudKitKanchuProjectRepository.deleteAllProjects()

        // 2단계: 로컬 데이터베이스에서 모든 프로젝트 가져오기
        let localProjects = try await kanchuProjectRepository.fetchAllProjects()

        // 3단계: 로컬 프로젝트를 CloudKit에 저장 (Repository에서 일괄 처리)
        try await cloudKitKanchuProjectRepository.saveProjects(localProjects)
    }

    func load() async throws {
        // 1단계: 로컬 데이터베이스의 모든 프로젝트 삭제
        try await kanchuProjectRepository.deleteAllProjects()

        // 2단계: CloudKit 백업에서 모든 프로젝트 가져오기
        let cloudProjects = try await cloudKitKanchuProjectRepository.fetchAllProjects()

        // 3단계: 클라우드 프로젝트를 로컬 데이터베이스에 저장
        try await kanchuProjectRepository.insertProjects(cloudProjects)
    }
}

// MARK: - Mock Service for Testing/Preview

final class MockICloudKanchuProjectService: ICloudKanchuProjectUseCase {
    func backup() async throws {
        // Simulate a 1-second network operation.
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }

    func load() async throws {
        // Simulate a 1-second network operation.
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
