//
//  BookmarksDTO.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/4/24.
//

import Foundation

struct BookmarksDTO: Codable {
    let id: Int
    let title: String
}

struct BookmarkedKanji: Codable {
    let bookmarksId: Int
    let kanjiId: Int
}

extension BookmarksDTO {
    func toDomain(_ kanjiList: [Kanji]) -> Bookmarks {
        .init(id: self.id, title: self.title, contents: kanjiList)
    }
}
