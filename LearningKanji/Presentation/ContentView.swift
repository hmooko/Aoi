//
//  ContentView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    let container: DIContainer
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TabView {
                HomeView(container: container)
                    .tabItem {
                        Image("open book")
                        Text("학습")
                    }
                
                SearchKanjiView(viewModel: .init(container))
                    .tabItem {
                        Image("magnifier")
                        Text("검색")
                    }
                
                BookmarksListView(viewModel: .init(container: container))
                    .tabItem {
                        Image("bookmark")
                        Text("북마크")
                    }
            }
            .aoiNavigationBar(router: router)
            .aoiNavigationDestination(container: container)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView(container: DIContainer())
        .environmentObject(DIContainer())
        .environmentObject(Router())
}
