//
//  UserInfoViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/7/25.
//

import Foundation
import os

extension UserInfoView {
    @MainActor
    final class ViewModel: ObservableObject {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "UserInfoView.ViewModel")

        // Use Cases (의존성 주입)
        private let getUserInfoUseCase: GetUserInfoUseCase
        private let getCurrentUserUseCase: GetCurrentUserUseCase
        private let signOutUseCase: SignOutUseCase // AuthRepository 대신 SignOutUseCase 주입

        // Published Properties (View의 상태)
        @Published var user: AoiUser?
        @Published var isLoading: Bool = false
        @Published var errorMessage: String?

        // MARK: - Initializer (Dependency Injection)
        init(container: DIContainer) {
            self.getUserInfoUseCase = container.getUserInfoUseCase()
            self.getCurrentUserUseCase = container.getCurrentUserUseCase()
            self.signOutUseCase = container.signOutUseCase() // SignOutUseCase 주입
        }

        // MARK: - Public Methods (View의 Action)

        /// 현재 로그인된 사용자의 정보를 로드합니다.
        func loadUserInfo() {
            guard let uid = getCurrentUserUseCase.execute() else {
                self.user = nil
                self.errorMessage = "로그인된 사용자가 없습니다."
                logger.warning("로그인된 Firebase 사용자가 없습니다.")
                return
            }

            isLoading = true
            errorMessage = nil

            Task {
                do {
                    let fetchedUser = try await getUserInfoUseCase.execute(uid: uid)
                    self.user = fetchedUser
                    logger.info("사용자 정보 로드 성공: \(fetchedUser?.email ?? "nil")")
                } catch {
                    self.errorMessage = error.localizedDescription
                    logger.error("사용자 정보 로드 실패: \(error.localizedDescription)")
                    print("이건가...?")
                }
                isLoading = false
            }
        }

        /// 사용자 로그아웃
        func logout() {
            do {
                try signOutUseCase.execute() // SignOutUseCase를 통해 로그아웃 실행
                self.user = nil
                self.errorMessage = nil
                logger.info("사용자 로그아웃 성공")
            } catch {
                self.errorMessage = "로그아웃 실패: \(error.localizedDescription)"
                logger.error("사용자 로그아웃 실패: \(error.localizedDescription)")
            }
        }
    }
}
