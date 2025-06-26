//
//  LoginView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/14/25.
//

import SwiftUI
import _AuthenticationServices_SwiftUI
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        SignInWithAppleButton { request in
            viewModel.onRequest(request: request)
        } onCompletion: { result in
            switch result {
            case .success(let authorization):
                print("Apple login successed")
                viewModel.loginCompletion(authorization: authorization)
            case .failure(let error):
                print("Apple login failed: \(error.localizedDescription)")
            }
        }
        .frame(height: 50)
        .padding()
    }
}



#Preview {
    LoginView(viewModel: LoginView.ViewModel())
}
