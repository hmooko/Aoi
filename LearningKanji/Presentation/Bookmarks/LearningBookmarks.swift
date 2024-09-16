//
//  LearningBookmarks.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/8/24.
//

import SwiftUI

struct LearningBookmarks: View {
    @EnvironmentObject private var router: Router
    @State private var learningMode: LearningMode = .list
    @State private var isCovered = false
    @State private var isRemove = false
    @StateObject private var coveredKanjiList = CoveredKanjiList()
    @StateObject private var viewModel: ViewModel
    
    init(_ viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        UISegmentedControl.appearance().backgroundColor = UIColor(named: "secondary")
    }
    
    var body: some View {
        VStack {
            switch learningMode {
            case .list:
                KanjiListView(
                    kanjiList: $viewModel.kanjiList,
                    coveredSoundAndMeaning: $isCovered
                )
            case .card:
                KanjiCardListView(
                    kanjiList: $viewModel.kanjiList,
                    coveredSoundAndMeaning: $isCovered
                )
            }
        }
        .environmentObject(coveredKanjiList)
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
                Picker("select viewMode", selection: $learningMode) {
                    Image(systemName: "list.bullet").tag(LearningMode.list)
                    Image(systemName: "list.bullet.rectangle.portrait").tag(LearningMode.card)
                }.pickerStyle(.segmented)
            }
        
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        router.push(.quizScene(viewModel.kanjiList))
                    } label: {
                        Text("퀴즈로 보기")
                    }
                    
                    Button {
                        withAnimation {
                            isCovered.toggle()
                        }
                    } label: {
                        if isCovered == true {
                            Image(systemName: "checkmark")
                        }
                        Text("한자만 보이기")
                    }
                    
                    Button("한자 섞기") {
                        withAnimation {
                            viewModel.kanjiList = viewModel.kanjiList.shuffled()
                        }
                    }
                    
                    Button("북마크 수정") {
                        router.push(.modifyBookmarksScene(viewModel.bookmarks))
                    }
                    .onChange(of: router.path) {
                        if router.path.count > 0 {
                            viewModel.fetchBookmarks()
                        }
                    }
                    
                    Button {
                        isRemove = true
                    } label: {
                        Text("북마크 삭제").font(.title2)
                    }.tint(.red)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(Color.white)
                }
            }
        }
        .alert(isPresented: $isRemove) {
            Alert(title: Text("정말로 삭제하시겠습니까?"), primaryButton: .destructive(Text("삭제"), action: {
                router.popToRoot()
                viewModel.deleteBookmarks(viewModel.bookmarks.id)
            }), secondaryButton: .cancel({isRemove = false}))
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .top) {
            VStack { }
                .frame(maxWidth: .infinity)
                .background(Color("primary"))
        }
        .navigationBarBackButtonHidden()
    }
    
    
}

extension LearningBookmarks {
    final class ViewModel: ObservableObject {
        let container: DIContainer
        @Published var bookmarks: Bookmarks
        @Published var kanjiList: [Kanji]
        
        init(_ bookmarks: Bookmarks, container: DIContainer) {
            self.bookmarks = bookmarks
            self.container = container
            self.kanjiList = bookmarks.contents
        }
        
        func fetchBookmarks() {
            container.bookmarksUseCase().fetchBookmarks { result in
                if case.success(let success) = result {
                    self.bookmarks = success.filter { $0.id == self.bookmarks.id }[0]
                    self.kanjiList = self.bookmarks.contents
                }
            }
        }
        
        func deleteBookmarks(_ bookmarksId: Int) {
            container.bookmarksUseCase().removeBookmarks(bookmarksId)
        }
    }
}

#Preview {
    LearningBookmarks(LearningBookmarks.ViewModel(
        Bookmarks(id: 1, title: "title", contents: Kanji.sampleKanjiList)
        ,container: DIContainer()
    ))
        .environmentObject(Router())
}
