//
//  BookmarksList.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/4/24.
//

import SwiftUI

private enum SelectedBookmarks {
    case notSelected
    case select(Bookmarks)
}


struct BookmarksList: View {
    @State private var selectedBookmarks: Bookmarks? = nil
    @EnvironmentObject var viewModel: BookmarksListViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.bookmarksList) { bookmarks in
                    HStack {
                        NavigationLink(value: AppScene.learningScene(bookmarks.contents)) {
                            HStack {
                                Text(bookmarks.title)
                                    .lineLimit(1)
                                    .font(.title3)
                                Spacer()
                            }.contentShape(Rectangle())
                        }
                        
                        Button {
                            selectedBookmarks = bookmarks
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                        }
                    }
                    .buttonStyle(.plain)
                    .padding()
                    
                    Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .opacity(bookmarks == viewModel.bookmarksList.last ? 0 : 1.0)
                }
                .modifier(BookmarksMenu(selectedBookmarks: $selectedBookmarks))
            }
            .frame(maxWidth: .infinity)
            .background(Color(.white))
            .clipShape(.rect(cornerRadius: 15))
        }
        .padding()
        .onChange(of: router.path) {
            viewModel.fetchBookmarksList()
        }
    }

}

#Preview {
    BookmarksList()
        .environmentObject(BookmarksListViewModel(container: DIContainer()))
        .environmentObject(Router())
}
