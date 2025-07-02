//
//  BookmarksCell.swift
//  LearningKanji
//
//  Created by koohyunmo on 6/30/25.
//

import SwiftUI

struct BookmarksCell: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: BookmarksListViewModel
    let bookmarks: Bookmarks
    let proxy: GeometryProxy
    
    var body: some View {
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
        .padding()
    }
}

#Preview {
    GeometryReader { proxy in
        BookmarksCell(bookmarks: Bookmarks(id: 1, title: "1학년 학습", contents: Kanji.sampleKanjiList), proxy: proxy)
    }
    .environmentObject(BookmarksListViewModel(container: DIContainer()))
    .environmentObject(Router())
}
