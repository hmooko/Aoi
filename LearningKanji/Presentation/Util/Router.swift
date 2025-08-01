//
//  Rout.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/29/24.
//

import Foundation
import SwiftUI

enum AppScene: Hashable {
    case settingScene
    case quizScene(_ kanjiList: [Kanji])
    case learningScene(_ kanjiList: [Kanji])
    case learningBookmarks(_ bookmarks: Bookmarks)
    case modifyBookmarksScene(_ bookmarks: Bookmarks)
    case todaysKanjiGradePickerScene 
    case signInScene
}

class Router: ObservableObject {
    @Published var path: [AppScene] = []
    
    func push(_ scene: AppScene) {
        path.append(scene)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

extension View {
    func aoiNavigationDestination(container: DIContainer) -> some View {
        self
            .navigationDestination(for: AppScene.self) { scene in
                Group {
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
                    case .signInScene:
                        LoginView(viewModel: LoginView.ViewModel())
                    }
                }
                .environmentObject(container)
                .environmentObject(container.router)
            }
    }
}

struct AoiNavigationView: View {
    @StateObject private var container: DIContainer
    @StateObject private var router: Router
    
    init(container: DIContainer) {
        self._container = .init(wrappedValue: container)
        self._router = .init(wrappedValue: container.router)
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ContentView(viewModel: .init(container: container))
                .aoiNavigationDestination(container: container)
                .environmentObject(container)
                .environmentObject(router)
        }
    }
}
