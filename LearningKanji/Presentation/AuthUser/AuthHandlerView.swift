//
//  AuthHandlerView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct AuthHandlerView: View {
    @State private var authUser: FirebaseAuth.User?
    @StateObject private var loginViewModel: LoginView.ViewModel
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
        _loginViewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        // onAppear에서 로그인 상태를 확인하고, authUser 상태를 업데이트합니다.
        // authUser의 상태에 따라 적절한 뷰를 보여줍니다.
        VStack {
            if authUser != nil {
                // --- 로그인 된 상태 ---
                UserInfoView(container: container)
            } else {
                // --- 로그인 안된 상태 ---
                LoginView(viewModel: loginViewModel)
            }
        }
        .onAppear {
            // Firebase Auth 상태 리스너. 앱 생명주기 동안 로그인 상태 변화를 감지합니다.
            Auth.auth().addStateDidChangeListener { _, user in
                self.authUser = user
                
                // 로그인 성공 시 LoginViewModel의 상태를 초기화하여
                // 다음에 로그아웃 후 다시 로그인할 때 UI가 정상적으로 보이도록 합니다.
                if user != nil, loginViewModel.state == .success {
                    loginViewModel.state = .idle
                }
            }
        }
    }
}

#Preview {
    AuthHandlerView(container: .preview)
}
