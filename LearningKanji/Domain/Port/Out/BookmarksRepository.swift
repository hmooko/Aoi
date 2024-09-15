//
//  BookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/2/24.
//

import Foundation

protocol BookmarksRepository {
    func fetchBookmarks(_ completion: @escaping (Result<[Bookmarks], Error>) -> Void)
    func createBookmarks(title: String)
    func bookmark(_ kanjiId: Int, bookmarksId: Int)
    func removeBookmarks(_ id: Int)
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int)
}
