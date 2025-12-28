//
//  FeedbackSheetView.swift
//  LearningKanji
//
//  Created by Gemini on 2025/12/26.
//

import SwiftUI

struct FeedbackSheetView: View {
    let urlString: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            FullWebView(urlString: urlString)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("오류 제보")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("닫기") {
                            dismiss()
                        }
                    }
                }
        }
    }
}
