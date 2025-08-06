//
//  BookmarksList.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/4/24.
//

import SwiftUI

struct BookmarksList: View {
    @State private var selectedBookmarks: Bookmarks? = nil
    @State private var pressedBookmarks: Bookmarks? = nil
    @EnvironmentObject var viewModel: BookmarksListViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView {
            GeometryReader { proxy in
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    ForEach(viewModel.bookmarksList) { bookmarks in
                        BookmarksCell(bookmarks: bookmarks, proxy: proxy)
                            .environmentObject(viewModel)
                    }
                }
            }.padding()
        }
        .onChange(of: router.path) {
            viewModel.fetchBookmarksList()
        }
        .onAppear {
            viewModel.fetchBookmarksList()
        }
    }

}

#Preview {
    BookmarksList()
        .environmentObject(BookmarksListViewModel(container: DIContainer()))
        .environmentObject(Router())
}
