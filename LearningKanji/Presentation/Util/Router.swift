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
