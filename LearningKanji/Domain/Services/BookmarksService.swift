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

final class MockBookmarksService: BookmarksUseCase {
    private var stubbedBookmarks: [Bookmarks]
    
    init(bookmarks: [Bookmarks] = [
        Bookmarks(id: 1, title: "예시 북마크 1", contents: Array(Kanji.sampleKanjiList.prefix(2))),
        Bookmarks(id: 2, title: "예시 북마크 2", contents: Array(Kanji.sampleKanjiList.suffix(2)))
    ]) {
        self.stubbedBookmarks = bookmarks
    }
    
    func fetchBookmarks() async throws -> [Bookmarks] {
        stubbedBookmarks
    }
    
    func createBookmarks(_ title: String) async throws {
        let new = Bookmarks(id: (stubbedBookmarks.last?.id ?? 0)+1, title: title, contents: [])
        stubbedBookmarks.append(new)
    }
    
    func bookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        guard let idx = stubbedBookmarks.firstIndex(where: { $0.id == bookmarksId }) else { return }
        if stubbedBookmarks[idx].contents.contains(where: { $0.id == kanjiId }) {
            throw BookmarksError.bookmarkedKanjiDuplicationError
        }
        var kanji = Kanji.sampleKanji
        kanji = Kanji(id: kanjiId, kanji: kanji.kanji, grade: kanji.grade, sound: kanji.sound, meaning: kanji.meaning, korean: kanji.korean)
        var contents = stubbedBookmarks[idx].contents
        contents.append(kanji)
        stubbedBookmarks[idx] = Bookmarks(id: stubbedBookmarks[idx].id, title: stubbedBookmarks[idx].title, contents: contents)
    }
    
    func removeBookmarks(_ id: Int) async throws {
        stubbedBookmarks.removeAll { $0.id == id }
    }
    
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        guard let idx = stubbedBookmarks.firstIndex(where: { $0.id == bookmarksId }) else { return }
        var b = stubbedBookmarks[idx]
        b = Bookmarks(id: b.id, title: b.title, contents: b.contents.filter { $0.id != kanjiId })
        stubbedBookmarks[idx] = b
    }
}
