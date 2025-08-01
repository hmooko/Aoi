//
//  ContentView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var appState: AppState
    @StateObject var viewModel: ViewModel
    
    var body: some View {
            TabView {
                HomeView(container: viewModel.container)
                    .tabItem {
                        Image("open book")
                        Text("학습")
                    }
                
                SearchKanjiView(viewModel: .init(viewModel.container))
                    .tabItem {
                        Image("magnifier")
                        Text("검색")
                    }
                
                BookmarksListView(viewModel: .init(container: viewModel.container))
                    .tabItem {
                        Image("bookmark")
                        Text("북마크")
                    }
            }
            .aoiNavigationBar(router: router)
            .navigationBarTitleDisplayMode(.inline)
            .alert(viewModel.alertTitle, isPresented: $viewModel.isAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
    }
}

#Preview {
    ContentView(viewModel: .init(container: DIContainer()))
        .environmentObject(DIContainer())
        .environmentObject(Router())
        .environmentObject(AppState())
}
