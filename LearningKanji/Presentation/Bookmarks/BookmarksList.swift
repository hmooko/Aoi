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
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                ForEach(viewModel.bookmarksList) { bookmarks in
                    BookmarksCell(bookmarks: bookmarks)
                        .environmentObject(viewModel)
                }.padding()
            }
        }
        .onAppear {
            viewModel.fetchBookmarksList()
        }
    }

}

#Preview {
    BookmarksList()
        .environmentObject(BookmarksListViewModel(container: .preview))
        .environmentObject(DIContainer.preview.router)
}
