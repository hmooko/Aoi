//
//  KanchuHomeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/22/25.
//

import SwiftUI

struct KanchuHomeView: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(container: DIContainer) {
        _viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
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
                }
            }
        }
        .background(Color(.systemGray6))
        .safeAreaInset(edge: .bottom, alignment: .trailing) {
            addProjectButton
        }
        .onAppear {
            viewModel.fetchAllKanchuProjects()
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
    }
    
    private var addProjectButton: some View {
        Button {
            viewModel.createQuiz()
        } label: {
            Image(systemName: "plus")
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.yellow)
        .clipShape(.rect(cornerRadius: 15))
        .padding(30)
    }
}

#Preview {
    KanchuHomeView(container: .preview)
}
