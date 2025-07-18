//
//  IcloudBackUpBookmarksService.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/16/25.
//

import Foundation

protocol ICloudBookmarksUseCase {
    func getIsBackingUp() -> Bool
    func setIsBackingUP(_ newValue: Bool)
    func getIsLoadingBackup() -> Bool
    func setIsLoadingBackup(_ newValue: Bool)
    func backup() async throws
    func load() async throws
}

final class ICloudBookmarksService: ICloudBookmarksUseCase {
    
    private let bookmarksRepository: BookmarksRepository
    private let cloudKitBookmarksRepository: CloudKitBookmarksRepository
    private let userDefaultsRepository: UserDefaultsRepository
    
    init(
        bookmarksRepository: BookmarksRepository,
        cloudKitBookmarksRepository: CloudKitBookmarksRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.bookmarksRepository = bookmarksRepository
        self.cloudKitBookmarksRepository = cloudKitBookmarksRepository
        self.userDefaultsRepository = userDefaultsRepository
    }
    
    func getIsBackingUp() -> Bool {
        userDefaultsRepository.getIsBackingUp()
    }
    
    func setIsBackingUP(_ newValue: Bool) {
        userDefaultsRepository.setIsBackingUP(newValue)
    }
    
    func getIsLoadingBackup() -> Bool {
        userDefaultsRepository.getIsLoadingBackup()
    }
    
    func setIsLoadingBackup(_ newValue: Bool) {
        userDefaultsRepository.setIsLoadingBackup(newValue)
    }
    
    func backup() async throws {
        print("백업 시작")
        userDefaultsRepository.setIsBackingUP(true)
        print("1단계: 클라우드 데이터 삭제 시작...")
        let cloudBookmarksList = try await cloudKitBookmarksRepository.fetchBookmarks()
        try await withThrowingTaskGroup(of: Void.self) { group in
            for bookmarks in cloudBookmarksList {
                group.addTask {
                    try await self.cloudKitBookmarksRepository.removeBookmarks(id: bookmarks.id)
                }
            }
            try await group.waitForAll()
        }
        print("클라우드에 있는 데이터 모두 삭제 완료")
        
        print("2단계: 로컬 데이터 업로드 시작...")
        let localBookmarksList = try await bookmarksRepository.fetchBookmarks()
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for bookmarks in localBookmarksList {
                group.addTask {
                    try await self.cloudKitBookmarksRepository.createBookmarksRecord(id: bookmarks.id, title: bookmarks.title)
                    for kanji in bookmarks.contents {
                        try await self.cloudKitBookmarksRepository.createBookmarkedKanjiRecord(bookmarksId: bookmarks.id, kanjiId: kanji.id)
                    }
                }
            }
            try await group.waitForAll()
        }
        userDefaultsRepository.setIsBackingUP(false)
        print("백업 완료")
    }
        
    func load() async throws {
        print("load 시작")
        userDefaultsRepository.setIsLoadingBackup(true)
        try await bookmarksRepository.removeAllBookmarks()
        
        let cloudBookmarksList = try await cloudKitBookmarksRepository.fetchBookmarks()
        
        for bookmarks in cloudBookmarksList {
            try await self.bookmarksRepository.createBookmarks(title: bookmarks.title, id: bookmarks.id)
            for kanji in bookmarks.contents {
                try await self.bookmarksRepository.bookmark(kanji.id, bookmarksId: bookmarks.id)
            }
        }
        userDefaultsRepository.setIsLoadingBackup(false)
        print("로컬에 데이터 저장 완료.")
    }
}

// MARK: - Mock Service for Testing/Preview
final class MockICloudBookmarksService: ICloudBookmarksUseCase {
    private var isBackingUp: Bool = false
    private var isLoadingBackup: Bool = false
    
    func getIsBackingUp() -> Bool { isBackingUp }
    func setIsBackingUP(_ newValue: Bool) { isBackingUp = newValue }
    func getIsLoadingBackup() -> Bool { isLoadingBackup }
    func setIsLoadingBackup(_ newValue: Bool) { isLoadingBackup = newValue }
    
    func backup() async throws {
        isBackingUp = true
        try await Task.sleep(nanoseconds: 3_000_000_000) // Simulate async
        isBackingUp = false
    }
    
    func load() async throws {
        isLoadingBackup = true
        try await Task.sleep(nanoseconds: 3_000_000_000) // Simulate async
        isLoadingBackup = false
    }
}
