//
//  AppState.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/1/25.
//

import Foundation

final class AppState: ObservableObject {
    @Published var isBlocking: Bool = false
    @Published var blockingMessage: String = ""
}
