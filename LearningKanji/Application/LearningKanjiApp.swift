//
//  LearningKanjiApp.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/24/24.
//

import SwiftUI
import FirebaseCore
import SwiftData

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
    private let container: DIContainer
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        container = DIContainer()
    }
    
    var body: some Scene {
        
        WindowGroup {
            AoiNavigationView(container: container)
            //AView()
        }
    }
}

struct AView: View {
    
    var body: some View {
        NavigationStack {
            TabView {
                VStack {
                    Text("hihi")
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "add")
                    Text("추가")
                }
                
                VStack {
                    
                }
                .tabItem {
                    Image(systemName: "minus")
                    Text("제거")
                }
            }
        }
    }
}
