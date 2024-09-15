//
//  LearningByGradeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/6/24.
//

import SwiftUI

struct LearningByGradeListView: View {
    let container: DIContainer
    private let grades: [Grade] = [.first, .second, .third, .forth, .fifth, .sixth, .middle]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("학년 별로 학습하기")
                .font(.system(size: 25, weight: .bold))
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 10))
            
            ForEach(grades, id: \.self) { grade in
                LearningByGradeRow(container, text: grade.rawValue, grade: grade)
                Divider().padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    .opacity(grade != .middle ? 1.0 : 0.0)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.white))
        .clipShape(.rect(cornerRadius: 15))
        .padding()
    }
}

#Preview {
    previewBackgrounds {
        LearningByGradeListView(container: DIContainer())
            .environmentObject(DIContainer())
    }
}
