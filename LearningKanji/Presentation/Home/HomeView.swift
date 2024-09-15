//
//  HomeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct HomeView: View, AppView {
    func scene() -> AppScene { .homeScene }
    
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading) {
                    Text("투데이")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    TodaysKanjiView(proxy: proxy, viewModel: TodaysKanjiViewModel(container: viewModel.container))
                    
                    Spacer(minLength: 30)
                    
                    TodaysQuizCard()
                        .shadow(radius: 5)
                    
                    Spacer(minLength: 30)
                    LearningByGradeListView(container: viewModel.container)
                        .shadow(radius: 5)
                }
            }
            .background(Color(.systemGray6))
            .scrollIndicators(.hidden)
        }
    }
}

class HomeViewModel: ObservableObject {
    let container: DIContainer
    
    init(_ container: DIContainer) {
        self.container = container
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(DIContainer()))
}
