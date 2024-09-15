//
//  BookmarksViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/5/24.
//

import Foundation

final class BookmarksListViewModel: ObservableObject {
    private let bookmarksUseCase: BookmarksUseCase
    let container: DIContainer
    @Published var bookmarksList: [Bookmarks] = []
    @Published var isFloatMakingBookmarksView = false
    @Published var searchText: String = ""
    
    init(container: DIContainer) {
        self.container = container
        self.bookmarksUseCase = container.makeBookmarksUseCase()
        fetchBookmarksList()
    }
    
    // MARK: - output
    func fetchBookmarksList() {
        bookmarksUseCase.fetchBookmarks { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let bookmarksList):
                self.bookmarksList = bookmarksList
            }
        }
    }
    
    // MARK: - input
    func createBookmarks(_ title: String) {
        bookmarksUseCase.createBookmarks(title)
        fetchBookmarksList()
    }
    
    func deleteBookmarks(_ id: Int) {
        bookmarksUseCase.removeBookmarks(id)
        fetchBookmarksList()
    }
}
