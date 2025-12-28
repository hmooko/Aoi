//
//  KanchuQuizViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/8/25.
//

import Foundation
import os

extension KanchuQuizView {
    @MainActor
    final class ViewModel: ObservableObject {
        private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "KanchuQuizViewModel")
        
        private struct DummyGetKanchuProblemsUseCase: GetKanchuProblemsUseCase {
            func execute(target: QuizTarget, problemType: ProblemType, count: Int) async throws -> [KanchuProblem] {
                throw NSError(domain: "DummyGetKanchuProblemsUseCase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dependency injection failed. No real implementation provided."])
            }
        }

        // MARK: - Use Cases
        private let getKanchuProblemsUseCase: GetKanchuProblemsUseCase
        private let calculateKanchuProblemsResultUseCase: CalculateKanchuProblemsResultUseCase
        private let bookmarksUseCase: BookmarksUseCase
        private let insertKanchuProjectUseCase: InsertKanchuProjectUseCase
        private var router: Router
        
        // MARK: - Published Properties (View의 상태)
        @Published var quizSettings = QuizSettings()
        @Published var errorMessage: String? = nil
        @Published private(set) var problems: [KanchuProblem] = []
        @Published private(set) var currentProblemIndex: Int = 0
        @Published private(set) var userAnswers: [UserAnswer] = []
        @Published private(set) var quizResult: QuizSessionResult?
        @Published private(set) var selectedChoice: String?
        @Published private(set) var isAnswered: Bool = false
        @Published private(set) var isLoading: Bool = false
        @Published private(set) var viewState: ViewState = .settings
        @Published private(set) var bookmarksTargets: [QuizTarget] = []
        
        enum ViewState {
            case settings
            case loading
            case quiz
            case results
        }
        
        struct QuizSettings {
            var target: QuizTarget = .elementary(grade: .first)
            var problemType: ProblemType = .findReading
            var count: Int = 5
        }
        
        var currentProblem: KanchuProblem? {
            guard problems.indices.contains(currentProblemIndex) else { return nil }
            return problems[currentProblemIndex]
        }
        
        // MARK: - Initializer (Dependency Injection). Handles dependency errors and triggers error alert if needed.
        
        init(container: DIContainer) {
            do {
                self.getKanchuProblemsUseCase = try container.getKanchuProblemsUsecase()
            } catch {
                self.getKanchuProblemsUseCase = DummyGetKanchuProblemsUseCase()
                self.errorMessage = error.localizedDescription
                self.viewState = .loading
            }
            self.calculateKanchuProblemsResultUseCase = container.calculateKanchuProblemsResult()
            self.bookmarksUseCase = container.bookmarksUseCase()
            self.router = container.router
            self.insertKanchuProjectUseCase = container.insertKanchuProjectUseCase()
            
            fetchBookmarksTargets()
        }
        
        // MARK: - Public Methods (View의 Action)
        
        /// 퀴즈 시작: 설정값에 따라 문제들을 가져옵니다.
        func startQuiz() {
            viewState = .loading
            isLoading = true
            
            Task {
                do {
                    let fetchedProblems = try await getKanchuProblemsUseCase.execute(
                        target: quizSettings.target,
                        problemType: quizSettings.problemType,
                        count: quizSettings.count
                    )
                    
                    // 상태 초기화
                    self.problems = fetchedProblems
                    self.currentProblemIndex = 0
                    self.userAnswers = []
                    self.quizResult = nil
                    self.isAnswered = false
                    self.selectedChoice = nil
                    
                    self.isLoading = false
                    self.viewState = .quiz
                    
                    let project = KanchuProject(
                        id: UUID(),
                        name: "\(self.quizSettings.target.getString()) - \(self.quizSettings.problemType.rawValue)",
                        createdAt: Date(),
                        questions: self.problems,
                        isPinned: false
                    )
                    
                    try await insertKanchuProjectUseCase.execute(projects: [project])
                    
                } catch {
                    // TODO: 에러 처리 UI 구현
                    print("Error fetching problems: \(error)")
                    self.isLoading = false
                    self.viewState = .settings // 에러 발생 시 설정 화면으로 복귀
                    self.errorMessage = error.localizedDescription
                }
            }
        }
        
        /// KanchuHomeView에서 프로젝트를 클릭하여 퀴즈를 바로 시작할 때 사용됩니다.
        func startQuiz(with project: KanchuProject) {
            self.problems = project.questions
            self.currentProblemIndex = 0
            self.userAnswers = []
            self.quizResult = nil
            self.isAnswered = false
            self.selectedChoice = nil
            
            self.isLoading = false
            self.viewState = .quiz
        }
        
        /// 답안 제출: 사용자의 선택을 처리하고 다음 문제로 넘어갑니다.
        func submitAnswer(for choice: String) {
            guard let currentProblem = currentProblem else { return }
            
            isAnswered = true
            selectedChoice = choice
            
            let userAnswer = UserAnswer(problem: currentProblem, submittedAnswer: choice)
            userAnswers.append(userAnswer)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.currentProblemIndex < self.problems.count - 1 {
                    self.goToNextProblem()
                } else {
                    self.finishQuiz()
                }
            }
        }
        
        /// 새로운 퀴즈 시작: 모든 상태를 초기화하고 설정 화면으로 돌아갑니다.
        func startNewQuiz() {
            viewState = .settings
        }
        
        func goHome() {
            router.popToRoot()
        }
        
        // MARK: - Private Methods
        
        private func goToNextProblem() {
            currentProblemIndex += 1
            isAnswered = false
            selectedChoice = nil
        }
        
        private func finishQuiz() {
            self.quizResult = calculateKanchuProblemsResultUseCase.execute(userAnswers: userAnswers)
            self.viewState = .results
        }
        
        private func fetchBookmarksTargets() {
            Task {
                do {
                    self.bookmarksTargets = try await bookmarksUseCase.fetchBookmarks()
                        .filter {
                            $0.contents.count >= 10
                        }
                        .map {
                            QuizTarget.bookmark(id: $0.id, name: $0.title)
                        }
                    logger.info("북마크 타겟들을 성공적으로 불러왔습니다.")
                } catch {
                    logger.error("북마크 타겟들을 불러오는데 실패했습니다: \(error)")
                }
            }
        }
    }
}

