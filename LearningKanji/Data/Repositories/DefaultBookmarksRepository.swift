//
//  BookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/3/24.
//

import Foundation
import SQLite3

private enum Table: String, CustomStringConvertible {
    case bookmarks = "bookmarks"
    case bookmarkedKanji = "bookmarked_kanji"
    
    var description: String { self.rawValue }
}

final class DefaultBookmarksRepository: BookmarksRepository {
    private let commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage
    
    var db: OpaquePointer?
    var path = "bookmarksDB.sqlite"
    
    init(commonlyUsedKanjiStorage: CommonlyUsedKanjiStorage) {
        self.commonlyUsedKanjiStorage = commonlyUsedKanjiStorage
        self.db = createDB()
        self.createTable(
            """
            CREATE TABLE IF NOT EXISTS \(Table.bookmarks) (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL
            );
            """
        )
        self.createTable(
            """
            CREATE TABLE IF NOT EXISTS \(Table.bookmarkedKanji) (
            bookmarks_id INTEGER NOT NULL,
            kanji_id INTEGER NOT NULL
            );
            """
        )
    }
    
    private func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(path)
            if sqlite3_open(filePath.path, &db) == SQLITE_OK {
                print("Success create db Path")
                return db
            }
        }
        catch {
            print("error in createDB")
        }
        print("error in createDB - sqlite3_open")
        return nil
    }
    
    private func createTable(_ query: String) {
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Creating table has been succesfully done. db: \(String(describing: self.db))")
                
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating table: \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
        }
        
        sqlite3_finalize(statement) // 메모리에서 sqlite3 할당 해제.
    }
    
    private func getBookmarks() -> [BookmarksDTO] {
        let query: String = "select * from \(Table.bookmarks);"
        var statement: OpaquePointer? = nil
        var result: [BookmarksDTO] = []
        
        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return result
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let id = sqlite3_column_int(statement, 0)
            let title = String(cString: sqlite3_column_text(statement, 1))
            
            result.append(BookmarksDTO(id: Int(id), title: title))
        }
        sqlite3_finalize(statement)
        
        return result
    }
    
    private func getBookmarkedKanji() -> [BookmarkedKanji] {
        let query: String = "select * from \(Table.bookmarkedKanji);"
        var statement: OpaquePointer? = nil
        var result: [BookmarkedKanji] = []

        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return result
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let bookmarksId = sqlite3_column_int(statement, 0)
            let kanjiId = sqlite3_column_int(statement, 1)
            
            result.append(BookmarkedKanji(bookmarksId: Int(bookmarksId), kanjiId: Int(kanjiId)))
        }
        sqlite3_finalize(statement)
        
        return result
    }
    
    func fetchBookmarks(_ completion: @escaping (Result<[Bookmarks], Error>) -> Void) {
        guard let kanjiList = commonlyUsedKanjiStorage.kanjiList else {
            completion(.failure(CommonlyUsedKanjiRepositoryError.notLoadCommonlyUsedKanji))
            return
        }
        
        var result: [Bookmarks] = []
        let bookmarksTable = getBookmarks()
        let bookmarkedKanjiTable = getBookmarkedKanji()
        
        for bookmarks in bookmarksTable {
            let bookmarkedKanjiList = bookmarkedKanjiTable.filter { $0.bookmarksId == bookmarks.id }
            result.append(bookmarks.toDomain(bookmarkedKanjiList.map { kanjiList[$0.kanjiId] }))
        }
        
        completion(.success(result))
    }
    
    func createBookmarks(title: String) {
        let insertQuery = "insert into \(Table.bookmarks) (id, title) values (?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 2, NSString(string: title).utf8String, -1, nil)
        }
        else {
            print("sqlite binding failure")
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("sqlite insertion success")
        }
        else {
            print("sqlite step failure")
        }
    }
    
    func bookmark(_ kanjiIdList: [Int], bookmarksId: Int) {
        let insertQuery = "insert into \(Table.bookmarkedKanji) (bookmarks_id, kanji_id) values (?, ?);"
        var statement: OpaquePointer? = nil
        
        for id in kanjiIdList {
            if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(bookmarksId))
                sqlite3_bind_int(statement, 2, Int32(id))
            }
            else {
                print("sqlite binding failure")
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("sqlite insertion success")
            }
            else {
                print("sqlite step failure")
            }
        }
    }
    
    func removeBookmarks(_ id: Int) {
        let DELETE_QUERY = "DELETE FROM \(Table.bookmarks) WHERE id = \(id)"
        var stmt:OpaquePointer?
        
        print(DELETE_QUERY)
        if sqlite3_prepare_v2(db, DELETE_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            return
        }
        sqlite3_finalize(stmt)
    }
    
    func removeBookmark(_ kanjiIdList: [Int], bookmarksId: Int) {
        for id in kanjiIdList {
            let DELETE_QUERY = "DELETE FROM \(Table.bookmarkedKanji) WHERE bookmarks_id = \(bookmarksId) AND kanji_id = \(id)"
            var stmt:OpaquePointer?
            
            print(DELETE_QUERY)
            if sqlite3_prepare_v2(db, DELETE_QUERY, -1, &stmt, nil) != SQLITE_OK{
                let errMsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing delete: v1\(errMsg)")
                return
            }
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errMsg = String(cString : sqlite3_errmsg(db)!)
                print("delete fail :: \(errMsg)")
                return
            }
            sqlite3_finalize(stmt)
        }
    }
}
