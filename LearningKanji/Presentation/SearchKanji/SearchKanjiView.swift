//
//  SearchKanjiView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/10/24.
//

import SwiftUI

struct SearchKanjiView: View {
    let editMode: EditMode
    @StateObject var viewModel: SearchKanjiViewModel
    @Binding var selections: Set<Int>
    
    init(_ container: DIContainer) {
        self._viewModel = StateObject(wrappedValue: SearchKanjiViewModel(container))
        self._selections = .constant([])
        self.editMode = .inactive
    }
    
    init(_ container: DIContainer, selections: Binding<Set<Int>>) {
        self._viewModel = StateObject(wrappedValue: SearchKanjiViewModel(container))
        self._selections = selections
        self.editMode = .active
    }
    
    var body: some View {
        VStack {
            searchBar
                .padding()
                .onChange(of: viewModel.text) {
                    viewModel.searchKanji()
                }
            
            List(viewModel.response, selection: $selections) { kanji in
                KanjiRow(kanji: kanji)
            }
            .scrollContentBackground(.hidden)
            //.environment(\.editMode, .constant(.active))
        }
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("검색", text: $viewModel.text)
        }
        .padding(10)
        .background(Color(.systemGray5))
        .clipShape(.rect(cornerRadius: 10))
    }
}

final class SearchKanjiViewModel: ObservableObject {
    private let searchKanjiUseCase: SearchKanjiUseCase
    @Published var text: String = ""
    @Published var response: [Kanji] = []
    
    init(_ container: DIContainer) {
        self.searchKanjiUseCase = container.makeSearchKanjiUseCase()
    }
    
    func searchKanji() {
        searchKanjiUseCase.execute(text) { result in
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
    SearchKanjiView(DIContainer())
}
