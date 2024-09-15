//
//  BookmarksMenu.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/10/24.
//

import Foundation
import SwiftUI

struct BookmarksMenu: ViewModifier {
    @EnvironmentObject var viewModel: BookmarksListViewModel
    @EnvironmentObject var router: Router
    @Binding var selectedBookmarks: Bookmarks?
    
    func body(content: Content) -> some View {
        content.sheet(isPresented: Binding<Bool>(get: { selectedBookmarks != nil}, set: { _ in })) {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedBookmarks!.title).font(.title)
                    Divider()
                    
                    Button {
                        router.push(.quizScene(selectedBookmarks!.contents))
                        selectedBookmarks = nil
                    } label: {
                        HStack {
                            Image(systemName: "book.pages")
                            Text("퀴즈로 보기").font(.title2)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    Button {
                        router.push(.modifyBookmarksScene(selectedBookmarks!))
                        selectedBookmarks = nil
                    } label: {
                        HStack {
                            Image(systemName: "text.badge.plus")
                            Text("북마크 수정하기").font(.title2)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    Button {
                        viewModel.deleteBookmarks(selectedBookmarks!.id)
                        selectedBookmarks = nil
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("북마크 삭제히기").font(.title2)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    Spacer()
                    
                }.buttonStyle(.plain)
                
                Spacer()
            }
            .padding(40)
            .presentationDetents([.medium])
        }
    }
}
