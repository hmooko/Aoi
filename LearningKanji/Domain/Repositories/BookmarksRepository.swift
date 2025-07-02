//
//  BookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/2/24.
//

import Foundation

protocol BookmarksRepository {
    func fetchBookmarks() async throws -> [Bookmarks]
    func createBookmarks(title: String) async throws
    func createBookmarks(title: String, id: Int) async throws
    func modifyBookmarks(id: Int, title: String) async throws
    func bookmark(_ kanjiId: Int, bookmarksId: Int) async throws
    func removeBookmarks(_ id: Int) async throws
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) async throws
    func removeAllBookmarks() async throws
}
