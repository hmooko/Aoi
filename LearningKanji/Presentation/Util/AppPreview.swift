//
//  AppPreview.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/29/24.
//

import Foundation
import SwiftUI

func previewBackgrounds(view: @escaping () -> some View) -> some View {
    return VStack {
        view()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGray6))
}
