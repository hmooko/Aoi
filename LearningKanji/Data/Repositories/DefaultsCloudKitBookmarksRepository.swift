//
//  DefaultsCloudKitBookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/16/25.
//

import Foundation
import CloudKit
import CryptoKit

final class DefaultsCloudKitBookmarksRepository: CloudKitBookmarksRepository {
    private let container = CKContainer.init(identifier: "iCloud.6554000732")
    private let commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage
    
    init(commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage) {
        self.commonlyUsedKanjiStorage = commonlyUsedKanjiStorage
    }
    
    func createBookmarksRecord(id: Int, title: String) {
        let recordID = CKRecord.ID(recordName: "\(id)")
        let record = CKRecord(recordType: "Bookmarks", recordID: recordID)
        record.setValuesForKeys(["id": id, "title": title])
        
        container.privateCloudDatabase.modifyRecords(
            saving: [record], deleting: [], savePolicy: .changedKeys
        ) { result in
            switch result {
            case .success(let success):
                print("저장완료! \(record)")
            case .failure(let error):
                print("에러 발생: \(error)")
            }
        }
    }
    
    func createBookmarkedKanjiRecord(bookmarksId: Int, kanjiId: Int) {
        let recordID = CKRecord.ID(recordName: "\(bookmarksId)-\(kanjiId)")
        let record = CKRecord(recordType: "BookmarkedKanji", recordID: recordID)
        record.setValuesForKeys(["bookmarks_id": bookmarksId, "kanji_id": kanjiId])
        
        container.privateCloudDatabase.modifyRecords(
            saving: [record], deleting: [], savePolicy: .changedKeys
        ) { result in
            switch result {
            case .success(let success):
                print("저장완료! \(record)")
            case .failure(let error):
                print("에러 발생: \(error)")
            }
        }
    }
    
    func fetchBookmarks(_ completion: @escaping (Result<[Bookmarks], Error>) -> Void) {
        guard let kanjiList = commonlyUsedKanjiStorage.kanjiList else {
            completion(.failure(CommonlyUsedKanjiRepositoryError.notLoadCommonlyUsedKanji))
            return
        }
        
        let query = CKQuery(recordType: "Bookmarks", predicate: NSPredicate(value: true)) // 모든 레코드
        print("실행3")

        container.privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("에러: \(error)")
                completion(.failure(error))
            } else {
                guard let records = records else {
                    return
                }
                let bookmarksDTOList = records.map { record in
                    let id = record["id"] as! Int
                    let title = record["title"] as! String
                    return BookmarksDTO(id: id, title: title)
                }
                
                var result: [Bookmarks] = []
                self.fetchBookmarkedKanjiRecord { fetchResult in
                    switch fetchResult {
                    case .success(let bookmarkedKanjiList):
                        for bookmarks in bookmarksDTOList {
                            let bookmarkedKanjiList = bookmarkedKanjiList.filter { $0.bookmarksId == bookmarks.id }
                            result.append(bookmarks.toDomain(bookmarkedKanjiList.map { kanjiList[$0.kanjiId] }))
                        }
                        completion(.success(result))
                    case .failure(let error):
                        print(error)
                    }
                }
                completion(.success(result))
            }
        }
    }
    
    func fetchBookmarksDTORecord(_ completion: @escaping (Result<[BookmarkedKanji], Error>) -> Void) {
        
    }
    
    func fetchBookmarkedKanjiRecord(_ completion: @escaping (Result<[BookmarkedKanji], Error>) -> Void) {
        let query = CKQuery(recordType: "BookmarkedKanji", predicate: NSPredicate(value: true)) // 모든 레코드

        container.privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                completion(.failure(error))
            } else {
                guard let records = records else {
                    return
                }
                let result = records.map { record in
                    let bookmarksId = record["bookmarks_id"] as! Int
                    let kanjiId = record["kanji_id"] as! Int
                    return BookmarkedKanji(bookmarksId: bookmarksId, kanjiId: kanjiId)
                }
                completion(.success(result))
            }
        }
    }
    
    func removeBookmarks(id: Int) {
        let recordID = CKRecord.ID(recordName: "\(id)")
        func delete(id: CKRecord.ID) {
            container.publicCloudDatabase.delete(withRecordID: id) { recordID, error in
                print("삭제완료:")
            }
        }

        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "BookmarkedKanji", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.database = container.privateCloudDatabase

        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                if record["bookmarks_id"] as! Int == id {
                    self.container.privateCloudDatabase.delete(withRecordID: recordID) { recordID, error in
                        print("삭제완료:")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }

        operation.start()
        
        container.privateCloudDatabase.delete(withRecordID: recordID) { recordID, error in
            print("삭제완료:")
        }
    }
    
    func removeBookmarkedKanji(bookmarksId: Int, kanjiId: Int) {
        let recordID = CKRecord.ID(recordName: "\(bookmarksId)-\(kanjiId)")
        container.privateCloudDatabase.delete(withRecordID: recordID) { recordID, error in
            print("삭제완료:")
        }
    }
}
