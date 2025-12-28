//
//  Rout.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/29/24.
//

import Foundation
import SwiftUI

enum AppScene: Hashable {
    // MARK: - Setting
    case settingScene
    case todaysKanjiGradePickerScene
    case accountCenterScene
    // MARK: - Home Tab
    case quizScene(_ kanjiList: [Kanji])
    case learningScene(_ kanjiList: [Kanji])
    // MARK: - Kanchu Tab
    case kanchuQuizScene
    case kanchuQuizWithProjectScene(_ project: KanchuProject)
    // MARK: - Bookmarks Tab
    case learningBookmarks(_ bookmarks: Bookmarks)
    case modifyBookmarksScene(_ bookmarks: Bookmarks)
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
                    // MARK: - Setting
                    case .settingScene:
                        SettingsView()
                    case .todaysKanjiGradePickerScene:
                        TodaysKanjiGradePicker()
                    case .accountCenterScene:
                        AuthHandlerView(container: container)
                    // MARK: - Home Tab
                    case .quizScene(let kanjiList):
                        LearningAtQuizView(viewModel: .init(container, quizList: kanjiList))
                    case .learningScene(let kanjiList):
                        LearningKanjiView(kanjiList: kanjiList)
                    // MARK: - Kanchu Tab
                    case .kanchuQuizScene:
                        KanchuQuizView(container: container)
                    case .kanchuQuizWithProjectScene(let project):
                        KanchuQuizView(project: project, container: container)
                    // MARK: - Bookmarks Tab
                    case .learningBookmarks(let bookmarks):
                        LearningBookmarks(.init(bookmarks, container: container))
                    case .modifyBookmarksScene(let bookmarks):
                        ModifyBookmarksView(container, bookmarks: bookmarks)
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
