//
//  TodaysKanjiView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct TodaysKanjiView: View {
    @StateObject private var viewModel: TodaysKanjiViewModel
    @Namespace var animation
    @State private var shouldAnimate = false
    @State private var selection = 0
    let proxy: GeometryProxy

    
    init(proxy: GeometryProxy, viewModel: TodaysKanjiViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.proxy = proxy
    }
    
    var body: some View {
        VStack {
            if shouldAnimate {
                VStack {
                    HStack {
                        Text("오늘의 한자")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .matchedGeometryEffect(id: "todaysKanjiTitle", in: animation)
                        
                        Spacer()
                    }
                    
                    ForEach(viewModel.todaysKanjiList.indices) { index in
                        TodaysKanjiCell(kanji: viewModel.todaysKanjiList[index])
                            .matchedGeometryEffect(id: "todaysKanji\(index)", in: animation)
                        Divider()
                    }
                    
                    Spacer()
                }
                .matchedGeometryEffect(id: "todaysKanjiBackground", in: animation)
                .frame(width: proxy.frame(in: .global).width, height: proxy.frame(in: .global).height)
                .background(Color(.white))
            } else {
                card
                    .shadow(radius: 5)
                    .padding()
            }
        }
        .onTapGesture {
            withAnimation(.spring) {
                shouldAnimate.toggle()
            }
        }
    }
    
    var card: some View {
        ZStack(alignment: .topLeading) {
            TabView(selection: $selection) {
                ForEach(viewModel.todaysKanjiList.indices) { index in
                    TodaysKanjiCell(kanji: viewModel.todaysKanjiList[index])
                        .matchedGeometryEffect(id: "todaysKanji\(index)", in: animation)
                }
            }
            .tabViewStyle(.page)
            .padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
            
            Text("오늘의 한자")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .matchedGeometryEffect(id: "todaysKanjiTitle", in: animation)
        }
        .background(Color(.white))
        .clipShape(.rect(cornerRadius: 15))
        .frame(height: 250)
        .matchedGeometryEffect(id: "todaysKanjiBackground", in: animation)
    }
}

#Preview {
    GeometryReader { proxy in
        previewBackgrounds {
            TodaysKanjiView(proxy: proxy, viewModel: TodaysKanjiViewModel(container: DIContainer()))
        }
    }
}
