//
//  IcloudBackUpBookmarksService.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/16/25.
//

import Foundation

protocol ICloudBookmarksUseCase {
    func backup() async throws
    func load() async throws
}

final class ICloudBookmarksService: ICloudBookmarksUseCase {
    private let bookmarksRepository: BookmarksRepository
    private let cloudKitBookmarksRepository: CloudKitBookmarksRepository
    
    init(bookmarksRepository: BookmarksRepository, cloudKitBookmarksRepository: CloudKitBookmarksRepository) {
        self.bookmarksRepository = bookmarksRepository
        self.cloudKitBookmarksRepository = cloudKitBookmarksRepository
    }
    
    func backup() async throws {
        print("백업 시작")
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
        print("백업 완료")
    }
        
    func load() async throws {
        print("load 시작")
        try await bookmarksRepository.removeAllBookmarks()
        
        let cloudBookmarksList = try await cloudKitBookmarksRepository.fetchBookmarks()
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            for bookmarks in cloudBookmarksList {
                group.addTask {
                    try await self.bookmarksRepository.createBookmarks(title: bookmarks.title, id: bookmarks.id)
                    for kanji in bookmarks.contents {
                        try await self.bookmarksRepository.bookmark(kanji.id, bookmarksId: bookmarks.id)
                    }
                }
            }
            try await group.waitForAll()
        }
        print("로컬에 데이터 저장 완료.")
    }
}
