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
                        }
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                        .onTapGesture {
                            viewModel.startQuiz(project: project)
                        }
                }
                
                addProjectButton
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            }
        }
        .background(Color(.systemGray6))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
            })
        }
        .onAppear {
            viewModel.fetchAllKanchuProjects()
        }
    }
    
    private var addProjectButton: some View {
        Button {
            viewModel.createQuiz()
        } label: {
            HStack {
                Spacer() // Pushes the content to the center
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("새 프로젝트 추가")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        Color.gray.opacity(0.5),
                        style: StrokeStyle(lineWidth: 2, dash: [6, 6])
                    )
            }
        }
    }
}

#Preview {
    KanchuHomeView(container: .preview)
}
