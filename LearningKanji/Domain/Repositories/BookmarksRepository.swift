//
//  BookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/2/24.
//

import Foundation

protocol BookmarksRepository {
    func fetchBookmarks() async throws -> [Bookmarks]
    func createBookmarks(title: String) async
    func createBookmarks(title: String, id: Int) async
    func modifyBookmarks(id: Int, title: String) async
    func bookmark(_ kanjiId: Int, bookmarksId: Int) async
    func removeBookmarks(_ id: Int) async
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) async
    func removeAllBookmarks() async
}
