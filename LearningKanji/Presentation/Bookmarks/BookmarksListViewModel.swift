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
        self.bookmarksUseCase = container.bookmarksUseCase()
        Task {
            do {
                try await performFetchBookmarksList()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - output
    private func performFetchBookmarksList() async throws {
        let bookmarksList = try await bookmarksUseCase.fetchBookmarks()
        await MainActor.run {
            self.bookmarksList = bookmarksList
        }
    }
    
    func fetchBookmarksList() {
        Task {
            do {
                try await performFetchBookmarksList()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - input
    func createBookmarks(_ title: String) {
        Task {
            do {
                try await bookmarksUseCase.createBookmarks(title)
                try await performFetchBookmarksList()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteBookmarks(_ id: Int) {
        Task {
            do {
                try await bookmarksUseCase.removeBookmarks(id)
                try await performFetchBookmarksList()
            } catch {
                print(error)
            }
        }
    }
}
