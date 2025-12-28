//
//  UserInfoView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/6/25.
//

import SwiftUI

struct UserInfoView: View {
    @StateObject private var viewModel: ViewModel

    init(container: DIContainer) {
        _viewModel = StateObject(wrappedValue: ViewModel(container: container))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("사용자 정보 불러오는 중...")
            } else if let user = viewModel.user {
                Text("사용자 정보")
                    .font(.largeTitle)
                    .padding()

                Form {
                    Section("계정 정보") {
                        HStack {
                            Text("UID")
                            Spacer()
                            Text(user.uid)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("이름")
                            Spacer()
                            Text(user.name.isEmpty ? "미제공" : user.name)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("이메일")
                            Spacer()
                            Text(user.email.isEmpty ? "미제공" : user.email)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("오류: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                Text("로그인된 사용자가 없습니다.")
            }

            // 로그아웃 버튼
            Button("로그아웃") {
                viewModel.logout()
            }
            .padding()
        }
        .navigationTitle("내 프로필")
        .onAppear {
            viewModel.loadUserInfo()
        }
    }
}

#Preview {
    // 프리뷰를 위해 Mock DIContainer 사용
    UserInfoView(container: .preview)
}

