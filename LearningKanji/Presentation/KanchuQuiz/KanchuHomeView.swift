//
//  KanchuHomeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/22/25.
//

import SwiftUI

struct KanchuHomeView: View {
    
    @StateObject private var viewModel: ViewModel
    private let container: DIContainer
    @State private var showSetKanchuSheet: Bool = false
    
    init(container: DIContainer) {
        self.container = container
        _viewModel = .init(wrappedValue: .init(container: container))
    }
    
    // MARK: - View Helpers for Error Alert
    
    /// viewModel.viewState가 error일 때 true를 반환하는 바인딩을 생성합니다.
    /// 알림창이 닫힐 때 viewState를 재설정하기 위해 사용됩니다.
    private var isShowingError: Binding<Bool> {
        Binding(
            get: {
                if case .error = viewModel.viewState {
                    return true
                }
                return false
            },
            set: { isShowing, _ in
                // 알림창이 닫히면(isShowing이 false가 되면) 상태를 초기화합니다.
                // 프로젝트를 다시 로드하여 UI를 새로고칩니다.
                if !isShowing {
                    viewModel.fetchAllKanchuProjects()
                }
            }
        )
    }

    /// viewModel.viewState에서 오류 메시지를 추출합니다.
    private var errorMessage: String {
        if case .error(let message) = viewModel.viewState {
            return message
        }
        return "알 수 없는 오류가 발생했습니다."
    }
    
    var body: some View {
        Group {
            ZStack {
                
                // 1. 구독 상태를 먼저 확인합니다.
                if viewModel.subscriptionStatus == nil {
                    // 구독 상태 확인 중...
                    ProgressView("구독 상태 확인 중...")
                } else if viewModel.subscriptionStatus == .free {
                    // 2. 무료 사용자일 경우 페이월을 표시합니다.
                    PayWallView()
                        .environmentObject(viewModel)
                } else {
                    switch viewModel.viewState {
                    case .loading:
                        ProgressView("프로젝트 로딩 중...")
                    case .loaded, .error:
                        // 데이터가 로드되었거나 오류가 발생했을 때 메인 컨텐츠를 표시합니다.
                        // 오류는 알림창으로 사용자에게 알려줍니다.
                        mainContent
                    }
                }
            }
        }
        .onAppear {
            // 유료 사용자일 경우에만 프로젝트를 가져옵니다.
            // 무료 사용자는 페이월을 보게 되므로 프로젝트를 로드할 필요가 없습니다.
            if viewModel.subscriptionStatus != nil && viewModel.subscriptionStatus != .free {
                viewModel.fetchAllKanchuProjects()
            }
        }
        .alert("프로젝트 이름 변경", isPresented: .init(get: { viewModel.projectToRename != nil }, set: { if !$0 { viewModel.cancelProjectRename() } }), presenting: viewModel.projectToRename) { _ in
            TextField("새로운 이름", text: $viewModel.newProjectName)
            
            Button("변경") {
                viewModel.commitProjectRename()
            }
            Button("취소", role: .cancel) { }
        } message: { project in
            Text("'\(project.name)' 프로젝트의 새로운 이름을 입력하세요.")
        }
        .sheet(isPresented: $showSetKanchuSheet) {
            SetKanchuView(container: container)
        }
        .alert("오류", isPresented: isShowingError) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private var mainContent: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.projects) { project in
                    KanchuProjectCard(project: project)
                        .environmentObject(viewModel)
                        .contextMenu {
                            Button(role: .destructive) {
                                withAnimation(.spring) {
                                    viewModel.deleteProject(project)
                                }
                            } label: {
                                Label("프로젝트 삭제", systemImage: "trash.fill")
                            }
                            
                            Button {
                                viewModel.selectProjectToRename(project)
                            } label: {
                                Label("이름 변경", systemImage: "pencil")
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                        .onTapGesture {
                            viewModel.startQuiz(project: project)
                        }
                    
                    if viewModel.projects.isEmpty {
                        AoiText("Plus 버튼을 눌러 문제를 생성해보세요!")
                    }
                }
            }
        }
        .background(Color.backgroundColor)
        .safeAreaInset(edge: .bottom) {
            HStack {
                setKanchuButton
                Spacer()
                addProjectButton
            }
            .padding(30)
        }
    }
    
    private var addProjectButton: some View {
        Button {
            if viewModel.isApiKeyEmpty() {
                showSetKanchuSheet = true
            } else {
                viewModel.createQuiz()
            }
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.white)
                .padding()
                .background(Color.primaryColor)
                .clipShape(.rect(cornerRadius: 15))
        }
    }
    
    private var setKanchuButton: some View {
        Button {
            showSetKanchuSheet = true
        } label: {
            Image(systemName: "gearshape.fill")
                .foregroundStyle(.white)
                .padding()
                .background(Color(.systemGray4))
                .clipShape(.rect(cornerRadius: 15))
        }
    }
}

#Preview {
    KanchuHomeView(container: .preview)
}
