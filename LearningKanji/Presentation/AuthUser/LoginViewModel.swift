//
//  LoginViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/14/25.
//
import Foundation
import AuthenticationServices
import os // os 프레임워크 임포트

extension LoginView {
    @MainActor
    final class ViewModel: ObservableObject {
        // MARK: - Properties
        @Published var state: State = .idle
        
        enum State: Equatable {
            case idle
            case loading
            case success
            case error(String)
        }

        private var currentNonce: String?
        private let signInWithAppleUseCase: SignInWithAppleUseCase
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LoginViewModel") // Logger 인스턴스 추가

        // MARK: - Initialization
        init(container: DIContainer) {
            self.signInWithAppleUseCase = container.signInWithAppleUseCase()
            logger.info("LoginViewModel이 초기화되었습니다.") // 초기화 로깅
        }

        // MARK: - Apple Sign-in Handlers
        func handleAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
            logger.debug("Apple Sign-in 요청을 처리합니다.") // 요청 처리 시작 로깅
            let nonce = NonceHelper.randomNonceString()
            currentNonce = nonce
            request.requestedScopes = [.fullName, .email]
            request.nonce = NonceHelper.sha256(nonce)
            logger.debug("Nonce가 생성되고 요청에 설정되었습니다.") // Nonce 설정 로깅
        }

        func handleAppleSignInCompletion(result: Result<ASAuthorization, Error>) {
            guard let nonce = currentNonce else {
                state = .error(SignInWithAppleUseCaseError.invalidState.localizedDescription)
                logger.error("유효하지 않은 nonce로 Apple Sign-in 완료 처리 실패: \(SignInWithAppleUseCaseError.invalidState.localizedDescription)") // 에러 로깅
                return
            }
            
            state = .loading
            logger.info("Apple Sign-in 완료 처리를 시작합니다. 상태: 로딩 중") // 완료 처리 시작 로깅

            Task {
                do {
                    switch result {
                    case .success(let authorization):
                        try await signInWithAppleUseCase.execute(authorization: authorization, nonce: nonce)
                        self.state = .success
                        logger.info("Apple Sign-in 성공. 상태: 성공") // 성공 로깅
                    case .failure(let error):
                        // 사용자가 로그인을 취소한 경우 에러로 처리하지 않고 idle 상태로 되돌립니다.
                        if let authError = error as? ASAuthorizationError, authError.code == .canceled {
                            self.state = .idle
                            logger.info("Apple Sign-in이 사용자에게 의해 취소되었습니다. 상태: 유휴") // 취소 로깅
                            return
                        }
                        self.state = .error(error.localizedDescription)
                        logger.error("Apple Sign-in 처리 중 오류 발생: \(error.localizedDescription, privacy: .public)") // 실패 로깅 (에러 메시지 공개)
                    }
                } catch {
                    self.state = .error(error.localizedDescription)
                    logger.error("Apple Sign-in 처리 중 예상치 못한 예외 발생: \(error.localizedDescription, privacy: .public)") // 예외 로깅 (에러 메시지 공개)
                }
            }
        }

    }
}
