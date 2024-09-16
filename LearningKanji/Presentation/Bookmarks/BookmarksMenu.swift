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
    @State private var isReomve = false
    @Binding var selectedBookmarks: Bookmarks?
    
    func body(content: Content) -> some View {
        content.sheet(isPresented: Binding<Bool>(get: { selectedBookmarks != nil }, set: { _ in selectedBookmarks = nil })) {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedBookmarks!.title).font(.title)
                    Divider()
                    
                    quizButton
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    modifyButton
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    removeButton
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    
                    Spacer()
                    
                }.buttonStyle(.plain)
                
                Spacer()
            }
            .padding(40)
            .presentationDetents([.medium])
        }
    }
    
    private var quizButton: some View {
        Button {
            router.push(.quizScene(selectedBookmarks!.contents))
            selectedBookmarks = nil
        } label: {
            HStack {
                Image(systemName: "book.pages")
                Text("퀴즈로 보기").font(.title2)
            }
        }
    }
    
    private var modifyButton: some View {
        Button {
            router.push(.modifyBookmarksScene(selectedBookmarks!))
            selectedBookmarks = nil
        } label: {
            HStack {
                Image(systemName: "text.badge.plus")
                Text("북마크 수정하기").font(.title2)
            }
        }
    }
    
    private var removeButton: some View {
        Button {
            isReomve = true
        } label: {
            HStack {
                Image(systemName: "trash")
                Text("북마크 삭제히기").font(.title2)
            }
        }
        .alert(isPresented: $isReomve) {
            Alert(title: Text("정말로 삭제하시겠습니까?"), primaryButton: .destructive(Text("삭제"), action: {
                viewModel.deleteBookmarks(selectedBookmarks!.id)
                selectedBookmarks = nil
            }), secondaryButton: .cancel({isReomve = false}))
        }
    }
}
