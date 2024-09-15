//
//  Rout.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/29/24.
//

import Foundation
import SwiftUI

protocol AppView {
    func scene() -> AppScene
}

enum AppScene: Hashable {
    case homeScene
    case settingScene
    case searchScene
    case bookmarksScene
    case quizScene(_ kanjiList: [Kanji])
    case learningScene(_ kanjiList: [Kanji])
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
