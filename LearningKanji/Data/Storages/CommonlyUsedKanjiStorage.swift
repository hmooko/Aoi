//
//  CommonlyUsedKanjiStorage.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/2/24.
//

import Foundation

enum StorageError: Error, LocalizedError {
    case fileNotFound
    case loadingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "한자 데이터 파일을 찾을 수 없습니다."
        case .loadingFailed(let error):
            return "한자 데이터를 로드하는 데 실패했습니다: \(error.localizedDescription)"
        }
    }
}

final class CommonlyUsedKanjiStorage {
    private(set) var kanjiList: [Kanji] = []
    
    static let shared = CommonlyUsedKanjiStorage()

    func load() async throws -> [Kanji] {
        if kanjiList.count != 0 {
            return kanjiList
        }
        
        let data: Data
        
        guard let file = Bundle.main.url(forResource: "japanese_kanji_2136.json", withExtension: nil)
        else {
            throw StorageError.fileNotFound
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            throw StorageError.loadingFailed(error)
        }
        
        do {
            let decoder = JSONDecoder()
            self.kanjiList = try decoder.decode([Kanji].self, from: data)
        } catch {
            throw StorageError.loadingFailed(error)
        }
        
        return kanjiList
    }
}
