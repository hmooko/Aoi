//
//  Bookmarks.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/2/24.
//

import Foundation

struct Bookmarks: Identifiable, Hashable {
    let id: Int
    let title: String
    let contents: [Kanji]
}
