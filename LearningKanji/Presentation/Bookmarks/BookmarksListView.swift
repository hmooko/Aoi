//
//  BookmarksView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/2/24.
//

import SwiftUI

struct BookmarksListView: View {
    @StateObject var viewModel: BookmarksListViewModel
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomTrailing) {
                BookmarksList().environmentObject(viewModel)
                
                self.createBookmarksButton
            }
            .background(Color(.systemGray6))
            
            if viewModel.isFloatMakingBookmarksView {
                MakingBookmarksView($viewModel.isFloatMakingBookmarksView) { title in
                    viewModel.createBookmarks(title)
                }
            }
        }
    }
    
    private var createBookmarksButton: some View {
        Button {
            withAnimation(.easeIn) {
                viewModel.isFloatMakingBookmarksView = true
            }
        } label: {
            Image(systemName: "doc.badge.plus")
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color(.blue))
        .clipShape(.circle)
        .padding(30)
    }
}

#Preview {
    BookmarksListView(viewModel: BookmarksListViewModel(container: DIContainer()))
}
