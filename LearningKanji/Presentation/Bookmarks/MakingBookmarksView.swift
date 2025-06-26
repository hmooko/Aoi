//
//  MakingBookmarksView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/5/24.
//

import SwiftUI

struct MakingBookmarksView: View {
    @FocusState private var isFocused: Bool
    @State private var title: String = ""
    @Binding private var isFloat: Bool
    private let createAction: (String) -> ()
    
    init(_ isFloat: Binding<Bool>, createAction: @escaping (String) -> ()) {
        self._isFloat = isFloat
        self.createAction = createAction
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                TextField("제목", text: self.$title)
                    .pretendardBold(size: 18)
                    .focused($isFocused)
                    .foregroundStyle(.black)
                    .background(Color(.systemGray6))
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            
            HStack {
                Button("취소") {
                    withAnimation(.easeOut) { isFloat = false }
                    isFocused = false
                    title = ""
                }
                .pretendardMedium(size: 18)
                .padding(10)
                .background(Color.white)
                .foregroundStyle(Color.black)
                .clipShape(.rect(cornerRadius: 10))
                
                Button("만들기") {
                    withAnimation(.easeOut) { isFloat = false }
                    createAction(title)
                    isFocused = false
                }
                .pretendardMedium(size: 18)
                .padding(10)
                .background(Color("primary"))
                .foregroundStyle(Color.white)
                .clipShape(.rect(cornerRadius: 10))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(.rect(cornerRadius: 5))
        .shadow(radius: 3)
        .padding(40)
        .onAppear {
            isFocused = true
        }
    }
}

#Preview {
    MakingBookmarksView(.constant(true), createAction:  { _ in })
}
