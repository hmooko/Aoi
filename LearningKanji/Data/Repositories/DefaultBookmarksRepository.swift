//
//  BookmarksRepository.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/3/24.
//

import Foundation
import SQLite3

enum SQLiteError: Error, LocalizedError {
    case prepareFailed
    case stepFailed
    case bindFailed
    
    var errorDescription: String? {
        switch self {
        case .prepareFailed:
            return "데이터베이스 준비에 실패했습니다"
        case .stepFailed:
            return "데이터베이스 작업 실행에 실패했습니다"
        case .bindFailed:
            return "데이터베이스 값 바인딩에 실패했습니다"
        }
    }
}

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
        
        sqlite3_finalize(statement) 
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
    
    func fetchBookmarks() async throws -> [Bookmarks] {
        async let kanjiList = try commonlyUsedKanjiStorage.load()
        
        var result: [Bookmarks] = []
        let bookmarksTable = getBookmarks()
        let bookmarkedKanjiTable = getBookmarkedKanji()
        
        do {
            let loadedKanjiList = try await kanjiList
            
            for bookmarks in bookmarksTable {
                let bookmarkedKanjiList = bookmarkedKanjiTable.filter { $0.bookmarksId == bookmarks.id }
                result.append(bookmarks.toDomain(bookmarkedKanjiList.map { loadedKanjiList[$0.kanjiId] }))
            }
        } catch {
            throw error
        }
        
        return result
    }
    
    func createBookmarks(title: String) async throws {
        let insertQuery = "insert into \(Table.bookmarks) (id, title) values (?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 2, NSString(string: title).utf8String, -1, nil)
        }
        else {
            throw SQLiteError.bindFailed
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("create bookmarks success \(title)")
        }
        else {
            throw SQLiteError.stepFailed
        }
    }
    
    func createBookmarks(title: String, id: Int) async throws {
        let insertQuery = "insert into \(Table.bookmarks) (id, title) values (?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            sqlite3_bind_text(statement, 2, NSString(string: title).utf8String, -1, nil)
        }
        else {
            throw SQLiteError.bindFailed
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("create bookmarks success \(title)")
        }
        else {
            throw SQLiteError.stepFailed
        }
    }
    
    func modifyBookmarks(id: Int, title: String) async throws {
        var statement: OpaquePointer?
        // 등호 기호는 =이 아니라 ==이다.
        // string 부분은 작은 따옴표 두 개로 감싸줘야 한다.
        let queryString = "UPDATE myTable SET title = '\(title)' WHERE id == \(id)"
        
        // 쿼리 준비.
        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing update: \(errorMessage)")
            throw SQLiteError.prepareFailed
        }
        // 쿼리 실행.
        if sqlite3_step(statement) != SQLITE_DONE {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing update: \(errorMessage)")
            throw SQLiteError.prepareFailed
        }
        
        print("Update has been successfully done")
    }
    
    func bookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        let insertQuery = "insert into \(Table.bookmarkedKanji) (bookmarks_id, kanji_id) values (?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(bookmarksId))
            sqlite3_bind_int(statement, 2, Int32(kanjiId))
        }
        else {
            throw SQLiteError.bindFailed
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("sqlite insertion success")
        }
        else {
            throw SQLiteError.stepFailed
        }
    }
    
    func removeBookmarks(_ id: Int) async throws {
        var stmt:OpaquePointer?
        
        // 북마크 id에 해당되는 한자들 삭제
        let DELETE_BOOKMARKED_KANJI_QUERY = "DELETE FROM \(Table.bookmarkedKanji) WHERE bookmarks_id = \(id)"
        
        if sqlite3_prepare_v2(db, DELETE_BOOKMARKED_KANJI_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            throw SQLiteError.prepareFailed
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            throw SQLiteError.prepareFailed
        }
        sqlite3_finalize(stmt)
        
        // 북마크 삭제
        let DELETE_BOOKMARKS_QUERY = "DELETE FROM \(Table.bookmarks) WHERE id = \(id)"

        if sqlite3_prepare_v2(db, DELETE_BOOKMARKS_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            throw SQLiteError.prepareFailed
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            throw SQLiteError.prepareFailed
        }
        sqlite3_finalize(stmt)
    }
    
    func removeBookmark(_ kanjiId: Int, bookmarksId: Int) async throws {
        let DELETE_QUERY = "DELETE FROM \(Table.bookmarkedKanji) WHERE bookmarks_id = \(bookmarksId) AND kanji_id = \(kanjiId)"
        var stmt:OpaquePointer?
        
        print(DELETE_QUERY)
        if sqlite3_prepare_v2(db, DELETE_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            throw SQLiteError.prepareFailed
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            throw SQLiteError.prepareFailed
        }
        sqlite3_finalize(stmt)
    }
    
    func removeAllBookmarks() async throws {
        let REMOVE_ALL_BOOKMARKS_QUERY = "DELETE FROM \(Table.bookmarks)"
        var stmt:OpaquePointer?
        
        print(REMOVE_ALL_BOOKMARKS_QUERY)
        if sqlite3_prepare_v2(db, REMOVE_ALL_BOOKMARKS_QUERY, -1, &stmt, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            throw SQLiteError.prepareFailed
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            throw SQLiteError.prepareFailed
        }
        sqlite3_finalize(stmt)
        
        let REMOVE_ALL_BOOKMARK_QUERY = "DELETE FROM \(Table.bookmarkedKanji)"
        
        print(REMOVE_ALL_BOOKMARK_QUERY)
        if sqlite3_prepare_v2(db, REMOVE_ALL_BOOKMARK_QUERY, -1, &stmt, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing delete: v1\(errMsg)")
            throw SQLiteError.prepareFailed
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("delete fail :: \(errMsg)")
            throw SQLiteError.prepareFailed
        }
        sqlite3_finalize(stmt)
    }
}
