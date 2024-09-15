//
//  ContentView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct ContentView: View {
    let container: DIContainer
    
    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel(container))
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("Learning")
                }
            
            BookmarksListView(viewModel: BookmarksListViewModel(container: container))
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("bookmarks")
                }
        }
        .navigationDestination(for: AppScene.self) { scene in
            switch scene {
            case .settingScene:
                SettingsView(viewModel: SettingsViewModel(container: container))
            case .homeScene:
                HomeView(viewModel: HomeViewModel(container))
            case .bookmarksScene:
                BookmarksListView(viewModel: BookmarksListViewModel(container: container))
            case .quizScene(let kanjiList):
                LearningAtQuizView(viewModel: LearningAtQuizViewViewModel(container, quizList: kanjiList))
            case .learningScene(let kanjiList):
                LearningKanjiView(kanjiList: kanjiList)
            case .searchScene:
                SearchKanjiView(container)
            case .modifyBookmarksScene(let bookmarks):
                ModifyBookmarksView(DIContainer(), bookmarks: bookmarks)
            }
        }
        .toolbar {
            ToolbarItem {
                NavigationLink(value: AppScene.searchScene) {
                    Image(systemName: "magnifyingglass")
                }
            }
            
            ToolbarItem {
                NavigationLink(value: AppScene.settingScene) {
                    Image(systemName: "person.crop.circle")
                }
            }
        }
    }
}

#Preview {
    ContentView(container: DIContainer())
        .environmentObject(DIContainer())
}
