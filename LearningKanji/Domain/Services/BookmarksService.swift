//
//  BookmarksUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/2/24.
//

import Foundation

protocol BookmarksUseCase {
    func fetchBookmarks() async throws -> [Bookmarks]
    func createBookmarks(_ title: String) async throws
    func bookmark(_ kanjiId: Int, bookmarksId: Int) async throws
    func removeBookmarks(_ id: Int) async throws
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) async throws
}

enum BookmarksError: Error, LocalizedError {
    case bookmarkedKanjiDuplicationError
    
    var errorDescription: String? {
        switch self {
        case .bookmarkedKanjiDuplicationError:
            return "북마크에 이미 같은 한자가 존재합니다."
        }
    }
}

final class BookmarksService: BookmarksUseCase {
    
    private let bookmarksRepository: BookmarksRepository
    
    init(bookmarksRepository: BookmarksRepository) {
        self.bookmarksRepository = bookmarksRepository
    }
    
    func fetchBookmarks() async throws -> [Bookmarks] {
        let bookmarksList: [Bookmarks] = try await bookmarksRepository.fetchBookmarks()
        
        return bookmarksList
    }
    
    func createBookmarks(_ title: String) async throws {
        try await bookmarksRepository.createBookmarks(title: title)
    }
    
    func bookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        let bookmarksList = try await fetchBookmarks()
        let bookmarks = bookmarksList.filter { $0.id == bookmarksId }
        if bookmarks[0].contents.contains(where: { kanji -> Bool in
            if kanji.id == kanjiId {
                return true
            } else {
                return false
            }
        }) {
            throw BookmarksError.bookmarkedKanjiDuplicationError
        } else {
            try await bookmarksRepository.bookmark(kanjiId, bookmarksId: bookmarksId)
        }
    }
    
    func removeBookmarks(_ id: Int) async throws {
        try await bookmarksRepository.removeBookmarks(id)
    }
    
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        try await bookmarksRepository.removeBookmark(kanjiId, bookmarksId: bookmarksId)
    }
}
