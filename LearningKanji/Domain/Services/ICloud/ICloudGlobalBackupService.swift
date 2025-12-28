//
//  ICloudGlobalBackupService.swift
//  LearningKanji
//
//  Created by AI Assistant on 8/19/25.
//

import Foundation

protocol ICloudGlobalBackupUseCase {
    func getIsBackingUp() -> Bool
    func getIsLoading() -> Bool
    
    func setIsBackingUp(_ isBackingUp: Bool)
    func setIsLoading(_ isLoading: Bool)
    
    func backupAll() async throws
    func loadAll() async throws
}

final class ICloudGlobalBackupService: ICloudGlobalBackupUseCase {
    
    private let bookmarksBackupService: ICloudBookmarksUseCase
    private let kanchuProjectBackupService: ICloudKanchuProjectUseCase
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(
        bookmarksBackupService: ICloudBookmarksUseCase,
        kanchuProjectBackupService: ICloudKanchuProjectUseCase,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.bookmarksBackupService = bookmarksBackupService
        self.kanchuProjectBackupService = kanchuProjectBackupService
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func getIsBackingUp() -> Bool {
        return userDefaultsRepository.getIsBackingUp()
    }
    
    func getIsLoading() -> Bool {
        return userDefaultsRepository.getIsLoadingBackup()
    }
    
    func setIsBackingUp(_ isBackingUp: Bool) {
        userDefaultsRepository.setIsBackingUP(isBackingUp)
    }
    
    func setIsLoading(_ isLoading: Bool) {
        userDefaultsRepository.setIsLoadingBackup(isLoading)
    }
    
    func backupAll() async throws {
        userDefaultsRepository.setIsBackingUP(true)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { try await self.bookmarksBackupService.backup() }
            group.addTask { try await self.kanchuProjectBackupService.backup() }
            try await group.waitForAll()
        }
        
        userDefaultsRepository.setIsBackingUP(false)
    }
    
    func loadAll() async throws {
        userDefaultsRepository.setIsLoadingBackup(true)
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { try await self.bookmarksBackupService.load() }
            group.addTask { try await self.kanchuProjectBackupService.load() }
            try await group.waitForAll()
        }
        
        userDefaultsRepository.setIsLoadingBackup(false)
    }
}

final class MockICloudGlobalBackupService: ICloudGlobalBackupUseCase {
    private var isBackingUp: Bool = false
    private var isLoading: Bool = false
    
    func getIsBackingUp() -> Bool { isBackingUp }
    func getIsLoading() -> Bool { isLoading }
    
    func setIsBackingUp(_ isBackingUp: Bool) {
        self.isBackingUp = isBackingUp
    }
    
    func setIsLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func backupAll() async throws {
        isBackingUp = true
        try await Task.sleep(nanoseconds: 2_000_000_000)
        isBackingUp = false
    }
    
    func loadAll() async throws {
        isLoading = true
        try await Task.sleep(nanoseconds: 2_000_000_000)
        isLoading = false
    }
}
