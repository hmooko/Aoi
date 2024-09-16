//
//  LearningKanjiApp.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/24.
//

import SwiftUI

@main
struct LearningKanjiApp: App {
    @StateObject private var container = DIContainer()
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
                .environmentObject(container)
                .environmentObject(router)
        }
    }
}
