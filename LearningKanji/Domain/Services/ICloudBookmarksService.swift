//
//  IcloudBackUpBookmarksService.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/16/25.
//

import Foundation

protocol ICloudBookmarksUseCase {
    func backup(completion: @escaping (Error?) -> Void)
    func load()
}

final class ICloudBookmarksService: ICloudBookmarksUseCase {
    private let bookmarksRepository: BookmarksRepository
    private let cloudKitBookmarksRepository: CloudKitBookmarksRepository
    
    init(bookmarksRepository: BookmarksRepository, cloudKitBookmarksRepository: CloudKitBookmarksRepository) {
        self.bookmarksRepository = bookmarksRepository
        self.cloudKitBookmarksRepository = cloudKitBookmarksRepository
    }
    
    func backup(completion: @escaping (Error?) -> Void) {
        let group = DispatchGroup()
        
        group.enter()
        cloudKitBookmarksRepository.fetchBookmarks { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let cloudBookmarksList):
                for bookmarks in cloudBookmarksList {
                    self.cloudKitBookmarksRepository.removeBookmarks(id: bookmarks.id)
                }
                group.leave()
                print("cloud에 있는 데이터 모두 삭제 완료")
            }
        }
        
        group.enter()
        bookmarksRepository.fetchBookmarks { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let localBookmarksList):
                for bookmarks in localBookmarksList {
                    self.cloudKitBookmarksRepository.createBookmarksRecord(id: bookmarks.id, title: bookmarks.title)
                    for kanji in bookmarks.contents {
                        self.cloudKitBookmarksRepository.createBookmarkedKanjiRecord(bookmarksId: bookmarks.id, kanjiId: kanji.id)
                    }
                }
                group.leave()
                print("backup complete")
            }
        }
        
        group.notify(queue: .main) {
            completion(nil)
        }
    }
        
    func load() {
        bookmarksRepository.removeAllBookmarks()
        
        cloudKitBookmarksRepository.fetchBookmarks { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let cloudBookmarksList):
                for bookmarks in cloudBookmarksList {
                    self.bookmarksRepository.createBookmarks(title: bookmarks.title)
                    for kanji in bookmarks.contents {
                        self.bookmarksRepository.bookmark(kanji.id, bookmarksId: bookmarks.id)
                    }
                }
            }
        }
    }
}
