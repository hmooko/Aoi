//
//  SetKanchuView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/13/25.
//

import SwiftUI
import StoreKit

extension SetKanchuView {
    
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var currentAI: (any AIModel)?
        @Published var apiKey: String = ""
        @Published private(set) var viewState: ViewState = .loading
        
        enum ViewState {
            case loading
            case loaded
            case error(String)
        }
        
        private let setAIModelUseCase: SetAIModelUseCase
        private let setKanchuAPIKeyUseCase: SetKanchuAPIKeyUseCase
        private let getAIModelUseCase: GetAIModelUseCase
        private let getKanchuAPIKeyUseCase: GetKanchuAPIKeyUseCase
        
        init(container: DIContainer) {
            self.setAIModelUseCase = container.setAIModelUseCase()
            self.getAIModelUseCase = container.getAIModelUseCase()
            self.setKanchuAPIKeyUseCase = container.setKanchuAPIKeyUseCase()
            self.getKanchuAPIKeyUseCase = container.getKanchuAPIKeyUseCase()
            
            initData()
        }
        
        func save() {
            setAPIKey()
            setAIModel()
        }
        
        private func setAPIKey() {
            setKanchuAPIKeyUseCase.execute(key: apiKey)
        }
        
        private func setAIModel() {
            setAIModelUseCase.execute(model: currentAI!)
            
        }
        
        private func initData() {
            do {
                try currentAI = getAIModelUseCase.execute()
            } catch {
                viewState = .error(error.localizedDescription)
            }
            apiKey = getKanchuAPIKeyUseCase.execute()
        }
    }
}

struct SetKanchuView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @StateObject private var viewModel: ViewModel
    
    @State private var googleAisExpanded: Bool = false
    @State private var subscriptionsExpanded: Bool = false
    @State private var guidePresented: Bool = false
    @State private var isAPIKeyGuidePresented: Bool = false
    
    private let geminiAPIKeyURL = URL(string: "https://aistudio.google.com/u/0/apikey")

    init(container: DIContainer) {
        _viewModel = .init(wrappedValue: ViewModel(container: container))
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "message.badge.waveform.fill")
                            .foregroundStyle(Color.primaryColor)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.tertiaryColor)
                            }
                        VStack(alignment: .leading) {
                            AoiText(viewModel.currentAI?.provider ?? "로딩 중...")
                            AoiText(viewModel.currentAI?.rawValue ?? "로딩 중...", size: 14)
                                .foregroundStyle(.gray)
                            
                        }
                        Spacer()
                    }
                } header: {
                    Text("현재 모델")
                } footer: {
                    VStack(alignment: .leading) {
                        AoiText("* AI 모델에 따라 문제 생성 시간과 문제의 퀄리티가 달라질 수 있습니다.", size: 11)
                    }
                    .foregroundStyle(.gray)
                }

                Section {
                    SecureField("API 키를 입력하세요.", text: $viewModel.apiKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.system(.body, design: .monospaced))
                } header: {
                    Text("API Key")
                } footer: {
                    VStack(alignment: .leading) {
                        AoiText("* 문제를 생성하기 위해 유효한 API 키가 필요합니다.", size: 11)
                    }
                    .foregroundStyle(.gray)
                }
                
                Section(header: Text("사용 가능한 AI")) {
                    DisclosureGroup("Google", isExpanded: $googleAisExpanded) {
                        ForEach(GeminiModel.allCases, id: \.self) { model in
                            Button {
                                viewModel.currentAI = model
                            } label: {
                                HStack {
                                    Text(model.rawValue)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .opacity(model.rawValue == viewModel.currentAI?.rawValue ? 1 : 0)
                                }
                                .foregroundStyle(.black)
                            }
                        }
                    }
                }
                
                Section("사용 가이드") {
                    Button("사용 가이드") {
                        guidePresented = true
                    }
                    .foregroundStyle(.black)
                    .sheet(isPresented: $guidePresented) {
                        KanchuIntroView()
                    }
                    
                    DisclosureGroup("API 키 발급 받으러 가기", isExpanded: $isAPIKeyGuidePresented) {
                        Button {
                            if let url = geminiAPIKeyURL {
                                openURL(url)
                            }
                        } label: {
                            HStack {
                                Text("Gemini")
                            }
                            .foregroundStyle(.black)
                        }
                    }
                }
                
                Section("구독 관리") {
                    Button("구독 관리") {
                        subscriptionsExpanded = true
                    }
                    .foregroundStyle(.black)
                    .manageSubscriptionsSheet(isPresented: $subscriptionsExpanded)
                }
            }
            .navigationTitle("AI 설정")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        viewModel.save()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SetKanchuView(container: .preview)
}
