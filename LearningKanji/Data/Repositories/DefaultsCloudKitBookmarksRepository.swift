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
    
    func createBookmarksRecord(id: Int, title: String) async throws {
        let recordID = CKRecord.ID(recordName: "\(id)")
        let record = CKRecord(recordType: "Bookmarks", recordID: recordID)
        record.setValuesForKeys(["id": id, "title": title])
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.privateCloudDatabase.modifyRecords(
                saving: [record], deleting: [], savePolicy: .changedKeys
            ) { result in
                switch result {
                case .success(let success):
                    print("저장완료! \(record)")
                    continuation.resume()
                case .failure(let error):
                    print("에러 발생: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func createBookmarkedKanjiRecord(bookmarksId: Int, kanjiId: Int) async throws {
        let recordID = CKRecord.ID(recordName: "\(bookmarksId)-\(kanjiId)")
        let record = CKRecord(recordType: "BookmarkedKanji", recordID: recordID)
        record.setValuesForKeys(["bookmarks_id": bookmarksId, "kanji_id": kanjiId])
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.privateCloudDatabase.modifyRecords(
                saving: [record], deleting: [], savePolicy: .changedKeys
            ) { result in
                switch result {
                case .success(let success):
                    print("저장완료! \(record)")
                    continuation.resume()
                case .failure(let error):
                    print("에러 발생: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchBookmarks() async throws -> [Bookmarks] {
        let kanjiList = try await commonlyUsedKanjiStorage.load()
        let bookmarkedKanjiList = try await self.fetchBookmarkedKanjiRecord()
        
        let query = CKQuery(recordType: "Bookmarks", predicate: NSPredicate(value: true)) // 모든 레코드
        print("실행3")

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[Bookmarks], Error>) in
            container.privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    print("에러: \(error)")
                    continuation.resume(throwing: error)
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
                    for bookmarks in bookmarksDTOList {
                        let filteredBookmarkedKanjiList = bookmarkedKanjiList.filter { $0.bookmarksId == bookmarks.id }
                        result.append(bookmarks.toDomain(filteredBookmarkedKanjiList.map { kanjiList[$0.kanjiId] }))
                    }
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func fetchBookmarkedKanjiRecord() async throws -> [BookmarkedKanji] {
        let query = CKQuery(recordType: "BookmarkedKanji", predicate: NSPredicate(value: true)) // 모든 레코드

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[BookmarkedKanji], Error>) in
            container.privateCloudDatabase.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    guard let records = records else {
                        return
                    }
                    let result = records.map { record in
                        let bookmarksId = record["bookmarks_id"] as! Int
                        let kanjiId = record["kanji_id"] as! Int
                        return BookmarkedKanji(bookmarksId: bookmarksId, kanjiId: kanjiId)
                    }
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func removeBookmarks(id: Int) async throws {
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
            
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            operation.recordMatchedBlock = { recordID, result in
                switch result {
                case .success(let record):
                    if record["bookmarks_id"] as! Int == id {
                        self.container.privateCloudDatabase.delete(withRecordID: recordID) { recordID, error in
                            print("삭제완료:")
                            continuation.resume()
                        }
                    }
                case .failure(let error):
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
            
            operation.start()
            
            container.privateCloudDatabase.delete(withRecordID: recordID) { recordID, error in
                print("삭제완료:")
                continuation.resume()
            }
        }
    }
    
    func removeBookmarkedKanji(bookmarksId: Int, kanjiId: Int) async {
        let recordID = CKRecord.ID(recordName: "\(bookmarksId)-\(kanjiId)")
        
        container.privateCloudDatabase.delete(withRecordID: recordID) { recordID, error in
            print("삭제완료:")
        }
    }
}
