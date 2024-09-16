//
//  BookmarksUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/8/24.
//

import Foundation

protocol BookmarksUseCase {
    func fetchBookmarks(_ completion: @escaping (Result<[Bookmarks], Error>) -> Void)
    func createBookmarks(_ title: String)
    func bookmark(_ kanjiId: Int, bookmarksId: Int) -> Bool
    func removeBookmarks(_ id: Int)
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int)
}

enum BookmarksError: Error {
    case bookmarkedKanjiDuplicationError
}
