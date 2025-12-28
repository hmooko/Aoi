//
//  FullWebView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/19/25.
//

import SwiftUI
import WebKit

struct FullWebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString), uiView.url != url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
