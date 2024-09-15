//
//  MainView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/19/24.
//

import SwiftUI

protocol HeroCard: View {
    associatedtype Card : View
    associatedtype cardDetail: View
    
    //var id: String { get }
    var card: Card { get }
    var cardDetail: cardDetail { get }
}

extension HeroCard {
    var body: some View {
        self.card
    }
}

struct ACard: HeroCard {
    @Namespace var animation
    @EnvironmentObject private var currentItem: CurrentAnimateHeroItem
    //var id: String = UUID().uuidString
    
    var card: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background {
            Rectangle()
                .fill(Color.blue)
                .matchedGeometryEffect(id: "shape", in: animation)
        }
        .padding()
        .onTapGesture {
            currentItem.setCurrentItem(heroCard: self)
        }
    }
    
    var cardDetail: some View {
        VStack {
            VStack {
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Rectangle()
                    .fill(Color.blue)
                    .matchedGeometryEffect(id: "shape", in: animation)
            }
            .ignoresSafeArea()
            .onTapGesture {
                currentItem.reset()
            }

        }
    }
}

final class CurrentAnimateHeroItem: ObservableObject {
    struct AbstractHeroCard: HeroCard {
        var card: some View { VStack {} }
        var cardDetail: some View { VStack {} }
    }
    
    @Published var currentItem: any HeroCard = AbstractHeroCard()
    
    func setCurrentItem(heroCard: any HeroCard) {
        currentItem = heroCard
    }
    
    func reset() {
        currentItem = AbstractHeroCard()
    }
}

struct HeroCardList<Content: View>: View {
    @StateObject private var currentItem = CurrentAnimateHeroItem()
    @ViewBuilder let content: Content
    
    var body: some View {
        ZStack {
            content
                .environmentObject(currentItem)
                
            
                
        }
    }
}

struct MainView: View {
    @Namespace var animation
    @State private var currentItem = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    ForEach(0..<2) { index in
                        VStack {
                            Text("\(index)")
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(.blue)
                        .padding()
                    }
                    
                    ACard()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                currentItem.toggle()
                            }
                            
                        }
                    //.gesture(DragGesture(minimumDistance: 0).onChanged({}))
                    
                    ForEach(2..<10) { index in
                        VStack {
                            Text("\(index)")
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(.blue)
                        .padding()
                    }
                }
            }
            .overlay {
                if currentItem {
                    ACard().cardDetail
                        .onTapGesture {
                            withAnimation(.spring()) {
                                currentItem.toggle()
                            }
                        }
                }
            }
        }.background(Color.gray)
    }
}

#Preview {
    MainView()
}

