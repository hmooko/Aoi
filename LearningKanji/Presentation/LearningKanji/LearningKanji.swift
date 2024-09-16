//
//  LearningKanji.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/15/24.
//

import Foundation
import SwiftUI

protocol LearningView: View {
    var swipeAction: any SwipeAction { get }
    var kanjiList: [Kanji] { get }
}

extension LearningView {
    var body: some View {
        List(kanjiList) { kanji in
            Text(kanji.kanji)
                .swipeActions {
                    AnyView(self.swipeAction.swipeAction())
                }
        }
    }
}
