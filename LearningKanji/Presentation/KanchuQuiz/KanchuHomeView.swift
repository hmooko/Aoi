//
//  KanchuHomeView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/22/25.
//

import SwiftUI

struct KanchuHomeView: View {
    
    //@StateObject private var viewModel: ViewModel
    
    init(container: DIContainer) {
        //_viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        List([createExampleProject()], id: \.id) { project in
            KanchuProjectCard(project: project)
        }
    }
    
    private struct KanchuProjectCard: View {
        let project: KanchuProject
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(project.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    HStack(spacing: 16) {
                        Label("\(project.questionCount)문제", systemImage: "number")
                        Label {
                            Text(project.createdAt, format: .dateTime.year().month().day())
                        } icon: {
                            Image(systemName: "calendar")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if project.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                }
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    KanchuHomeView(container: .preview)
}

