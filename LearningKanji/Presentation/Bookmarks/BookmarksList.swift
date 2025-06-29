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
                        VStack {
                            Text(bookmarks.title)
                                .pretendardBold(size: 18)
                            
                            Spacer()
                            
                            HStack {
                                Button {
                                    viewModel.fetchBookmarksList()
                                    router.push(.learningBookmarks(bookmarks))
                                } label: {
                                    Text("학습")
                                        .pretendardBold(size: 15)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(5)
                                        .background {
                                            RoundedRectangle(cornerRadius: 50)
                                                .fill(Color("primary"))
                                        }
                                }.buttonStyle(.plain)
                                
                                Button {
                                    viewModel.fetchBookmarksList()
                                    router.push(.quizScene(bookmarks.contents))
                                } label: {
                                    Text("퀴즈")
                                        .pretendardMedium(size: 15)
                                        .foregroundStyle(Color("primary"))
                                        .frame(maxWidth: .infinity)
                                        .padding(5)
                                        .background {
                                            RoundedRectangle(cornerRadius: 50)
                                                .fill(Color("tertiary"))
                                        }
                                }.buttonStyle(.plain)
                            }
                        }
                        .padding(30)
                        .frame(width: proxy.size.width / 2.3, height: proxy.size.width / 2.3, alignment: .topLeading)
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.white))
                                .stroke(Color("secondary"))
                                .shadow(color: Color("shadow"), radius: 13.9, y: 4)
                        }
                        .scaleEffect(pressedBookmarks == bookmarks ? 0.9 : 1)
                        .animation(.easeIn, value: pressedBookmarks == bookmarks)
                        .padding()
                    }
                }
            }.padding()
        }
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
