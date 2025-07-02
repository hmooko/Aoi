//
//  LearningKanjiApp.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct LearningKanjiApp: App {
    @StateObject private var container = DIContainer()
    @StateObject private var router = Router()
    @StateObject private var appState = AppState()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(container: container))
                .environmentObject(container)
                .environmentObject(router)
                .environmentObject(appState)
        }
    }
}
