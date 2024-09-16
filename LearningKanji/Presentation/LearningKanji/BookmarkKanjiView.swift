//
//  BookmarkKanjiView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/24.
//

import SwiftUI

struct BookmarkKanjiView: View {
    @StateObject private var viewModel: ViewModel
    
    init(_ kanji: Kanji, container: DIContainer) {
        _viewModel = StateObject(wrappedValue: ViewModel(kanji, container: container))
    }
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    List {
                        Section("북마크") {
                            ForEach(viewModel.bookmarksList) { bookmarks in
                                Button {
                                    viewModel.bookmark(bookmarksId: bookmarks.id)
                                } label: {
                                    Text("\(bookmarks.title)")
                                        .pretendardMedium(size: 18)
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                }
                
                Button {
                    viewModel.isMakeBookmarks = true
                } label: {
                    HStack {
                        Text("새 북마크")
                            .pretendardMedium(size: 18)
                    }
                    .foregroundStyle(Color(.white))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color("primary"))
                    }
                    .padding()
                }
            }
            
            if viewModel.isMakeBookmarks {
                MakingBookmarksView($viewModel.isMakeBookmarks) { title in
                    viewModel.createAndBookmark(title: title)
                }
            }
        }
            
        .alert("\(viewModel.alertMessage)", isPresented: $viewModel.alertShown) {
            Button("OK", role: .cancel) { }
        }
    }
}

extension BookmarkKanjiView {
    final class ViewModel: ObservableObject {
        let container: DIContainer
        private let bookmarksUseCase: BookmarksUseCase
        @Published var bookmarksList: [Bookmarks] = []
        @Published var kanji: Kanji
        @Published var alertMessage: String = ""
        @Published var alertShown = false
        @Published var isMakeBookmarks = false
        
        init(_ kanji: Kanji, container: DIContainer) {
            self.kanji = kanji
            self.container = container
            bookmarksUseCase = container.bookmarksUseCase()
            fetchBookmarksList()
        }
        
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
        
        func bookmark(bookmarksId: Int) {
            if !bookmarksUseCase.bookmark(kanji.id, bookmarksId: bookmarksId) {
                alertMessage = "이미 추가된 한자입니다."
                alertShown = true
            } else {
                self.alertMessage = "추가되었습니다."
                self.alertShown = true
            }
        }
        
        func createAndBookmark(title: String) {
            self.bookmarksUseCase.createBookmarks(title)
            self.fetchBookmarksList()
            if let bookmarks = bookmarksList.filter({ $0.title == title}).first {
                self.bookmark(bookmarksId: bookmarks.id)
            }
        }
    }
}

#Preview {
    BookmarkKanjiView(Kanji.sampleKanji, container: DIContainer())
}
