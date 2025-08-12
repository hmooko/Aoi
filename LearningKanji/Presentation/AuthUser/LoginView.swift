//
//  LoginView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/14/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            switch viewModel.state {
            case .idle:
                Image("Aoi")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
                
                Text("간편하게 로그인하고\n학습을 시작하세요")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                SignInWithAppleButton(
                    .signIn,
                    onRequest: viewModel.handleAppleSignInRequest,
                    onCompletion: viewModel.handleAppleSignInCompletion
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal)
                
            case .loading:
                ProgressView("로그인 중...")
                
            case .success:
                // 성공 상태는 AuthHandlerView에서 처리하므로
                // 보통 이 뷰는 보이지 않고 바로 화면이 전환됩니다.
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                Text("로그인 성공!")

            case .error(let message):
                VStack {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text("오류가 발생했습니다")
                        .font(.headline)
                        .padding(.top)
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("다시 시도") {
                        viewModel.state = .idle
                    }
                    .padding(.top)
                }
            }
        }
        .navigationTitle("로그인")
    }
}




#Preview {
    LoginView(viewModel: LoginView.ViewModel(container: .preview))
}
