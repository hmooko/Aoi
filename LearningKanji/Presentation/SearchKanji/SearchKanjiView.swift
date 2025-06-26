//
//  SearchKanjiView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/10/24.
//

import SwiftUI

struct SearchKanjiView: View {
    @StateObject var viewModel: SearchKanjiViewModel
    
    var body: some View {
        List(viewModel.response) { kanji in
            KanjiRow(kanji: kanji)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        viewModel.selectedKanji = kanji
                    } label: {
                        Image(systemName: "bookmark")
                    }.tint(Color("primary"))
                }
        }
        .sheet(item: $viewModel.selectedKanji, content: { kanji in
            BookmarkKanjiView(kanji, container: viewModel.container)
        })
        .safeAreaInset(edge: .top) {
            searchBar
                .onChange(of: viewModel.text) {
                    viewModel.searchKanji()
                }
        }
    }
    
    @ViewBuilder private var searchBar: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
                TextField("한자를 검색하세요", text: $viewModel.text)
                    .pretendardBold(size: 18)
                    .foregroundStyle(.white)
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 15, trailing: 20))
            .background(Color("primary"))
            
            Divider()
        }
    }
}

final class SearchKanjiViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var response: [Kanji] = []
    @Published var selectedKanji: Kanji? = nil
    
    let container: DIContainer
    
    init(_ container: DIContainer) {
        self.container = container
    }
    
    func searchKanji() {
        container.searchKanjiUseCase().execute(text) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let response):
                self.response = response
            }
        }
    }
}

#Preview {
    SearchKanjiView(viewModel: .init(DIContainer()))
}
