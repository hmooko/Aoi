//
//  TodaysKanjiView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct TodaysKanjiView: View {
    @EnvironmentObject private var router: Router
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("pin")
                
                Text("오늘의 한자")
                    .pretendardBold(size: 23)
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            TabView(selection: $viewModel.selection) {
                ForEach(viewModel.todaysKanjiList) { kanji in
                    TodaysKanjiCell(kanji: kanji)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 240)
        }
        .onChange(of: router.path) {
            viewModel.fetchTodaysKanjiList()
        }
    }
}

#Preview("card") {
    GeometryReader { proxy in
        previewBackgrounds {
            TodaysKanjiView(viewModel: .init(container: DIContainer()))
                .environmentObject(Router())
        }
    }
}
