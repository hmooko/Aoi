//
//  NoticeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/19/25.
//

import SwiftUI
import WebKit

// Full WebView for the sheet
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

struct NoticeView: View {
    @State private var showNoticeSheet = false
    private let urlString = "https://selective-wave-059.notion.site/253a33b6fe4f80bba823d56d8b629cde?source=copy_link"

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("book")
                
                Text("공지사항")
                    .pretendardBold(size: 23)
            }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

            
            Image("notice_banner")
                .resizable()
                .scaledToFill()
                .frame(height: 80, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
                .onTapGesture {
                    self.showNoticeSheet = true
                }
                .shadow(color: Color("shadow"), radius: 13.9, y: 4)
        }
        .sheet(isPresented: $showNoticeSheet) {
            // Use a separate view for the sheet content for clarity
            NoticeSheetView(urlString: urlString)
        }
    }
}

struct NoticeSheetView: View {
    let urlString: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            FullWebView(urlString: urlString)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("공지사항")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("닫기") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
    }
}


#Preview {
    NoticeView()
}
