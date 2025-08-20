//
//  ContentView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    @StateObject var viewModel: ViewModel
    
    var body: some View {
            TabView {
                HomeView(container: viewModel.container)
                    .tabItem {
                        Image("open book")
                        Text("학습")
                    }
                    .aoiNavigationBar(router: router)
                
                SearchKanjiView(viewModel: .init(viewModel.container))
                    .tabItem {
                        Image("magnifier")
                        Text("검색")
                    }
                
                KanchuHomeView(container: viewModel.container)
                    .tabItem {
                        Image("AoiIcon")
                        Text("AI문제")
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
    let container = DIContainer.preview
    
    ContentView(viewModel: .init(container: container))
        .environmentObject(container)
        .environmentObject(container.router)
}
