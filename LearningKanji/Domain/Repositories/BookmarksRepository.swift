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

final class MockBookmarksRepository: BookmarksRepository {
    private var bookmarksList: [Bookmarks] = [
        Bookmarks(
            id: 1,
            title: "기본 북마크",
            contents: Array(Kanji.sampleKanjiList.prefix(2))
        ),
        Bookmarks(
            id: 2,
            title: "JLPT 단어",
            contents: Array(Kanji.sampleKanjiList.suffix(2))
        ),
        Bookmarks(
            id: 3,
            title: "비어있는 북마크",
            contents: []
        )
    ]
    private var nextId: Int = 4
    
    func fetchBookmarks() async throws -> [Bookmarks] {
        bookmarksList
    }
    
    func createBookmarks(title: String) async throws {
        let newBookmarks = Bookmarks(id: nextId, title: title, contents: [])
        bookmarksList.append(newBookmarks)
        nextId += 1
    }
    
    func createBookmarks(title: String, id: Int) async throws {
        let newBookmarks = Bookmarks(id: id, title: title, contents: [])
        bookmarksList.append(newBookmarks)
        nextId = max(nextId, id + 1)
    }
    
    func modifyBookmarks(id: Int, title: String) async throws {
        guard let idx = bookmarksList.firstIndex(where: { $0.id == id }) else { return }
        bookmarksList[idx] = .init(id: id, title: title, contents: bookmarksList[idx].contents)
    }
    
    func bookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        guard let idx = bookmarksList.firstIndex(where: { $0.id == bookmarksId }) else { return }
        if !bookmarksList[idx].contents.map({$0.id}).contains(kanjiId) {
            let original = bookmarksList[idx]
            bookmarksList[idx] = Bookmarks(id: original.id, title: original.title, contents: original.contents + [Kanji(id: kanjiId, kanji: "테스트", grade: "", sound: "테스트", meaning: "테스트", korean: "테스트")])
        }
    }
    
    func removeBookmarks(_ id: Int) async throws {
        bookmarksList.removeAll { $0.id == id }
    }
    
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        guard let idx = bookmarksList.firstIndex(where: { $0.id == bookmarksId }) else { return }
        let original = bookmarksList[idx]
        let newContents = original.contents.filter { $0.id != kanjiId }
        bookmarksList[idx] = Bookmarks(id: original.id, title: original.title, contents: newContents)
    }
    
    func removeAllBookmarks() async throws {
        bookmarksList.removeAll()
        nextId = 1
    }
}

