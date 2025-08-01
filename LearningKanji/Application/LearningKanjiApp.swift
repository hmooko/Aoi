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
    private let container: DIContainer = DIContainer()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            AoiNavigationView(container: container)
        }
    }
}
