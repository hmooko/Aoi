//
//  Color.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/22/25.
//

import SwiftUI

extension Color {
    static let primaryColor = Color("primary")
    static let secondaryColor = Color("secondary")
    static let tertiaryColor = Color("tertiary")
    static let backgroundColor = Color("background")
}

struct AoiText: View {
    let text: String
    let font: Font
    
    enum AoiFont {
        case pretendardBold
        case pretendardMedium
        case pretendardLight
    }
    
    init(
        _ text: String,
        font: AoiText.AoiFont = .pretendardMedium,
        size: CGFloat = 17
    ) {
        self.text = text
        switch font {
        case .pretendardBold:
            self.font = .custom("Pretendard-Bold", size: size)
        case .pretendardMedium:
            self.font = .custom("Pretendard-Medium", size: size)
        case .pretendardLight:
            self.font = .custom("Pretendard-Light", size: size)
        }
    }
    
    var body: some View {
        Text(text)
            .font(font)
    }
}
