//
//  HomeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: Router
    let container: DIContainer
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading) {
                    TodaysKanjiView(viewModel: .init(container: container))
                    
                    LearningByGradeListView(container: container)
                }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            }.scrollIndicators(.hidden)
            
            Divider()
        }
        .background(Color("background"))
    }
}

#Preview {
    HomeView(container: DIContainer())
        .environmentObject(Router())
}
