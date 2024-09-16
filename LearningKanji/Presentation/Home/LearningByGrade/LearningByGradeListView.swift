//
//  LearningByGradeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct LearningByGradeListView: View {
    let container: DIContainer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image("pencil")
                
                Text("학년 별로 학습하기")
                    .pretendardBold(size: 20)
            }.padding()
            
            gradeIndicator(text: "초등학교")
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach([Grade]([.first, .second, .third, .forth, .fifth, .sixth]), id: \.self) { grade in
                        LearningByGradeRow(container, grade: grade)
                    }
                    Spacer()
                }
            }.scrollIndicators(.hidden)
            
            gradeIndicator(text: "중학교")
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(1..<7, id: \.self) { index in
                        LearningByGradeRow(container, grade: Grade.middle, index: index)
                    }
                    Spacer()
                }
            }.scrollIndicators(.hidden)
        }
    }
}

extension LearningByGradeListView {
    private func gradeIndicator(text: String) -> some View {
        Text("# \(text)")
            .pretendardMedium(size: 15)
            .foregroundStyle(Color("primary"))
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            .frame(width: 100)
            .background {
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color("primary"), lineWidth: 1.5)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}

#Preview {
    LearningByGradeListView(container: DIContainer())
            .environmentObject(DIContainer())
            .environmentObject(Router())
}
