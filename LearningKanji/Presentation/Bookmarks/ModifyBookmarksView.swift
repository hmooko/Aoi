//
//  AddBookmarksView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/11/24.
//

import SwiftUI

struct ModifyBookmarksView: View {
    @StateObject private var viewModel: ViewModel
    @EnvironmentObject private var router: Router

    init(_ container: DIContainer, bookmarks: Bookmarks) {
        let viewModel = StateObject(wrappedValue: ViewModel(container, bookmarks: bookmarks))
        self._viewModel = viewModel
    }
    
    var body: some View {
        SearchKanjiView(viewModel.container, selections: $viewModel.selections)
            .environment(\.editMode, .constant(EditMode.active))
            .toolbar {
                Button("완료") {
                    viewModel.modify()
                    router.pop()
                }
            }
    }
}

extension ModifyBookmarksView {
    private final class ViewModel: ObservableObject {
        private let bookmarksUseCase: BookmarksUseCase
        let container: DIContainer
        let bookmarks: Bookmarks
        @Published var selections: Set<Int>
        
        init(_ container: DIContainer, bookmarks: Bookmarks) {
            self.container = container
            self.bookmarks = bookmarks
            self.bookmarksUseCase = container.makeBookmarksUseCase()
            self.selections = Set(bookmarks.contents.map { $0.id })
        }
        
        private func bookmark(_ kanjiIdList: Set<Int>, id: Int) {
            bookmarksUseCase.bookmark(Array(kanjiIdList), bookmarksId: id)
        }
        
        private func removeBookmark(_ kanjiIdList: Set<Int>, id: Int) {
            bookmarksUseCase.removeBookmark(Array(kanjiIdList), bookmarksId: id)
        }
        
        func modify() {
            let original = Set(bookmarks.contents.map { $0.id})
            
            let removed = original.subtracting(selections)
            let added = selections.subtracting(original)
            
            removeBookmark(removed, id: bookmarks.id)
            bookmark(added, id: bookmarks.id)
        }
    }
}

#Preview {
    ModifyBookmarksView(DIContainer(), bookmarks: Bookmarks(id: 0, title: "test", contents: Kanji.sampleKanjiList))
        .environmentObject(BookmarksListViewModel(container: DIContainer()))
}
