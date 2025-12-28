//
//  ButtonStyle.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import SwiftUI

/// 버튼을 눌렀을 때 작아지는 효과를 주는 ButtonStyle
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
