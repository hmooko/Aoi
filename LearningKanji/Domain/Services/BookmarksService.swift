//
//  BookmarksUseCase.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/2/24.
//

import Foundation

final class BookmarksService: BookmarksUseCase {
    private let bookmarksRepository: BookmarksRepository
    
    init(bookmarksRepository: BookmarksRepository) {
        self.bookmarksRepository = bookmarksRepository
    }
    
    func fetchBookmarks(_ completion: @escaping (Result<[Bookmarks], Error>) -> Void) {
        bookmarksRepository.fetchBookmarks { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let bookmarks):
                completion(.success(bookmarks))
            }
        }
    }
    
    func createBookmarks(_ title: String) {
        bookmarksRepository.createBookmarks(title: title)
    }
    
    func bookmark(_ kanjiId: Int, bookmarksId: Int) -> Bool {
        var isSuccess = true
        
        fetchBookmarks { result in
            switch result {
            case .failure(let error):
                isSuccess = true
            case.success(let bookmarksList):
                let bookmarks = bookmarksList.filter { $0.id == bookmarksId }
                if bookmarks[0].contents.contains(where: { kanji -> Bool in
                    if kanji.id == kanjiId {
                        return true
                    } else {
                        return false
                    }
                }) {
                    isSuccess = false
                }
                
            }
        }
        
        if isSuccess {
            bookmarksRepository.bookmark(kanjiId, bookmarksId: bookmarksId)
        }
        return isSuccess
    }
    
    func removeBookmarks(_ id: Int) {
        bookmarksRepository.removeBookmarks(id)
    }
    
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) {
        bookmarksRepository.removeBookmark(kanjiId, bookmarksId: bookmarksId)
    }
    
    
}
