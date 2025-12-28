//
//  NoticeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/19/25.
//

import SwiftUI
import WebKit

struct NoticeView: View {
    @State private var showNoticeSheet = false
    private let urlString = "https://selective-wave-059.notion.site/253a33b6fe4f80bba823d56d8b629cde?source=copy_link"

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "speaker.wave.3")
                    .resizable()
                    .frame(width: 18, height: 14)
                    .padding(7)
                    .background {
                        Circle()
                            .fill(Color(.systemGray4))
                    }
                AoiText("[공지사항]")
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .shadow(color: Color("shadow"), radius: 13.9, y: 4)
            }
            .padding()
            //.padding(.horizontal)
            .onTapGesture {
                showNoticeSheet = true
            }
            
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
