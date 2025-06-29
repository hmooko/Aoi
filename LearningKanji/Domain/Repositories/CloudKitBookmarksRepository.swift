//
//  CloudKitBookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/16/25.
//

import Foundation

protocol CloudKitBookmarksRepository {
    func createBookmarksRecord(id: Int, title: String) async throws
    func createBookmarkedKanjiRecord(bookmarksId: Int, kanjiId: Int) async throws
    func fetchBookmarks() async throws -> [Bookmarks]
    func removeBookmarks(id: Int) async throws
    func removeBookmarkedKanji(bookmarksId: Int, kanjiId: Int) async
}
