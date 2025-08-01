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
        List {
            ForEach(viewModel.projects) { project in
                KanchuProjectCard(project: project)
                    .environmentObject(viewModel)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .background(Color(.systemGray6))
    }
    
    private struct KanchuProjectCard: View {
        let project: KanchuProject
        @EnvironmentObject var viewModel: KanchuHomeView.ViewModel
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Text(project.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    HStack(spacing: 16) {
                        Text("\(project.questionCount)문제")
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                            Text(project.createdAt, format: .dateTime.year().month().day())
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }
                
                Spacer()
                
                if project.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                        .onTapGesture {
                            viewModel.togglePin(for: project)
                        }
                } else {
                    Image(systemName: "pin")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            viewModel.togglePin(for: project)
                        }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

#Preview {
    KanchuHomeView(container: .preview)
}

