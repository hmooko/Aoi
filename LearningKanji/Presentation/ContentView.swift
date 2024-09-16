//
//  ContentView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    let container: DIContainer
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView {
                HomeView(container: container)
                    .tabItem {
                        Image("open book")
                        Text("학습")
                    }
                
                SearchKanjiView(viewModel: .init(container))
                    .tabItem {
                        Image("magnifier")
                        Text("검색")
                    }
                
                BookmarksListView(viewModel: .init(container: container))
                    .tabItem {
                        Image("bookmark")
                        Text("북마크")
                    }
            }
            .aoiNavigationBar(router: router)
            .aoiNavigationDestination(container: container)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension View {
    func aoiNavigationDestination(container: DIContainer) -> some View {
        self
            .navigationDestination(for: AppScene.self) { scene in
                switch scene {
                case .settingScene:
                    SettingsView()
                case .quizScene(let kanjiList):
                    LearningAtQuizView(viewModel: .init(container, quizList: kanjiList))
                case .learningScene(let kanjiList):
                    LearningKanjiView(kanjiList: kanjiList)
                case .learningBookmarks(let bookmarks):
                    LearningBookmarks(.init(bookmarks, container: container))
                case .modifyBookmarksScene(let bookmarks):
                    ModifyBookmarksView(container, bookmarks: bookmarks)
                case .todaysKanjiGradePickerScene:
                    TodaysKanjiGradePicker()
                }
            }
    }
}

#Preview {
    ContentView(container: DIContainer())
        .environmentObject(DIContainer())
        .environmentObject(Router())
}
