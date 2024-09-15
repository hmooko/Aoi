//
//  TodaysQuizView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/18/24.
//

import SwiftUI

struct TodaysQuizCard: View {
    var body: some View {
        VStack {
            Text("오늘의 퀴즈")
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(Color(.white))
        .clipShape(.rect(cornerRadius: 15))
        .padding()
    }
}

#Preview {
    previewBackgrounds {
        TodaysQuizCard()
    }
}
