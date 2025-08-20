//
//  AoiCard.swift
//  LearningKanji
//
//  Created by AI Assistant on 8/18/25.
//

import SwiftUI

struct AoiCard: View {
    private let number: Int
    private let title: String
    private let imageSource: String
    private let description: String
    private let cornerRadius: CGFloat
    private let contentPadding: CGFloat
    private let backgroundColor: Color
    //private let content: Content

    init(
        number: Int,
        title: String,
        imageSource: String,
        description: String,
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 30,
        backgroundColor: Color = .white,
        //@ViewBuilder content: () -> Content
    ) {
        self.number = number
        self.title = title
        self.imageSource = imageSource
        self.description = description
        self.cornerRadius = cornerRadius
        self.contentPadding = padding
        self.backgroundColor = backgroundColor
        //self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 15) {
                AoiText("\(number)", font: .pretendardBold, size: 22)
                    .padding(15)
                    .background {
                        Circle()
                            .fill(Color.tertiaryColor)
                    }
                AoiText(title, font: .pretendardBold, size: 25)
            }
            Image(imageSource)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .shadow(radius: 15)
                
            AoiText(description)
                .frame(maxWidth: .infinity)
        }
        .padding(contentPadding)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    ScrollView {
        AoiCard(
            number: 1,
            title: "나만의 퀴즈 만들기",
            imageSource: "home0",
            description: "홈 화면의 '+' 버튼을 눌러 학습할 대상(학년, 단어장 등)과 문제 유형, 개수를 자유롭게 선택하고 '퀴즈 시작' 버튼을 누르세요."
        )
        .padding()
    }
    .background(Color.primaryColor)
    
}
