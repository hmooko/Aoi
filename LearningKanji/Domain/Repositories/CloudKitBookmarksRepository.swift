//
//  CloudKitBookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/16/25.
//

import Foundation

protocol CloudKitBookmarksRepository {
    func createBookmarksRecord(id: Int, title: String)
    func createBookmarkedKanjiRecord(bookmarksId: Int, kanjiId: Int)
    func fetchBookmarks(_ completion: @escaping (Result<[Bookmarks], Error>) -> Void)
    func removeBookmarks(id: Int)
    func removeBookmarkedKanji(bookmarksId: Int, kanjiId: Int)
}
