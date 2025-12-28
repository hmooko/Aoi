//
//  KanjiListVIew.swift
//  LearningKanji
//
//  Created by koohyunmo on 4/7/24.
//

import SwiftUI

struct KanjiListView: View {
    @State private var selectedKanjiForBookmark: Kanji? = nil
    @Binding var kanjiList: [Kanji]
    @Binding var coveredSoundAndMeaning: Bool
    @EnvironmentObject var coveredKanjiList: CoveredKanjiList
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var container: DIContainer
    
    @State private var feedbackData: SheetData?
    
    // MARK: - Google Form Configuration
    private let googleFormBaseURL = "https://docs.google.com/forms/d/e/1FAIpQLSdtOFxnjtQfhq67-j8yCP6AERI9xdyUNdYyOpkjETMh9zbczg/viewform"
    private let entryIDForKanjiID = "entry.39191127"
    private let entryIDForKanjiChar = "entry.1218406551"
    
    var body: some View {
        VStack {
            List(kanjiList) { kanji in
                ZStack {
                    FlipableKanjiRow(kanji: kanji)
                        .opacity(coveredSoundAndMeaning ? 1.0 : 0)
                    
                    KanjiRow(kanji: kanji)
                        .opacity(coveredSoundAndMeaning ? 0 : 1.0)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        selectedKanjiForBookmark = kanji
                    } label: {
                        Label("북마크", systemImage: "bookmark")
                    }.tint(Color("primary"))
                    
                    Button {
                        openFeedbackForm(for: kanji)
                    } label: {
                        Label("오류 제보", systemImage: "exclamationmark.bubble")
                    }
                    .tint(.orange)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("background"))
        }
        .sheet(item: $selectedKanjiForBookmark, content: { kanji in
            BookmarkKanjiView(kanji, container: container)
        })
        .sheet(item: $feedbackData) { data in
            SafariView(url: data.url)
                .ignoresSafeArea()
        }
    }
    
    private func openFeedbackForm(for kanji: Kanji) {
        var components = URLComponents(string: googleFormBaseURL)
        components?.queryItems = [
            URLQueryItem(name: "usp", value: "pp_url"),
            URLQueryItem(name: entryIDForKanjiID, value: String(kanji.id)),
            URLQueryItem(name: entryIDForKanjiChar, value: kanji.kanji)
        ]
        
        if let url = components?.url {
            self.feedbackData = SheetData(url: url)
        }
    }
}

#Preview {
    KanjiListView(kanjiList: .constant([Kanji.sampleKanji, Kanji.sampleKanji, Kanji.sampleKanji]), coveredSoundAndMeaning: .constant(false))
        .environmentObject(CoveredKanjiList())
        .environmentObject(Router())
        .environmentObject(DIContainer())
}
