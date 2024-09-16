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
        List(viewModel.response, selection: $viewModel.selections) { kanji in
            KanjiRow(kanji: kanji, isModify: true)
        }
        .scrollContentBackground(.hidden)
        .background(Color("background"))
        .scrollContentBackground(.hidden)
        .safeAreaInset(edge: .top) {
            searchBar
                .onChange(of: viewModel.text) {
                    viewModel.searchKanji()
                }
        }
            .environment(\.editMode, .constant(EditMode.active))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("완료") {
                        viewModel.modify()
                        router.pop()
                    }
                    .foregroundStyle(.white)
                }
            }
            .navigationBarBackButtonHidden()
            .safeAreaInset(edge: .top) {
                VStack { }
                    .frame(maxWidth: .infinity)
                    .background(Color("primary"))
            }
            .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    @ViewBuilder private var searchBar: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
                TextField("한자를 검색하세요", text: $viewModel.text)
                    .pretendardBold(size: 18)
                    .foregroundStyle(.white)
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 15, trailing: 20))
            .background(Color("primary"))
            
            Divider()
        }
    }
}

extension ModifyBookmarksView {
    private final class ViewModel: ObservableObject {
        private let bookmarksUseCase: BookmarksUseCase
        let container: DIContainer
        let bookmarks: Bookmarks
        @Published var selections: Set<Int>
        @Published var text: String = ""
        @Published var response: [Kanji] = []
        
        init(_ container: DIContainer, bookmarks: Bookmarks) {
            self.container = container
            self.bookmarks = bookmarks
            self.bookmarksUseCase = container.bookmarksUseCase()
            self.selections = Set(bookmarks.contents.map { $0.id })
        }
        
        private func bookmark(_ kanjiIdList: Set<Int>, bookmarksId: Int) {
            for id in kanjiIdList {
                bookmarksUseCase.bookmark(id, bookmarksId: bookmarksId)
            }
        }
        
        private func removeBookmark(_ kanjiIdList: Set<Int>, bookmarksId: Int) {
            for id in kanjiIdList {
                bookmarksUseCase.removeBookmark(id, bookmarksId: bookmarksId)
            }
        }
        
        func modify() {
            let original = Set(bookmarks.contents.map { $0.id})
            
            let removed = original.subtracting(selections)
            let added = selections.subtracting(original)
            
            removeBookmark(removed, bookmarksId: bookmarks.id)
            bookmark(added, bookmarksId: bookmarks.id)
        }
        
        func searchKanji() {
            container.searchKanjiUseCase().execute(text) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let response):
                    self.response = response
                }
            }
        }
    }
}

#Preview {
    ModifyBookmarksView(DIContainer(), bookmarks: Bookmarks(id: 0, title: "test", contents: Kanji.sampleKanjiList))
        .environmentObject(BookmarksListViewModel(container: DIContainer()))
        .environmentObject(Router())
}
