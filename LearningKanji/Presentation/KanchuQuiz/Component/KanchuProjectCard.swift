//
//  KanchuProjectCard.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/3/25.
//

import SwiftUI

struct KanchuProjectCard: View {
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
                    Text("\(project.questions.count)문제")
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
        .padding(.vertical, 8)
        .padding(.horizontal)  
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        }
    }
}

#Preview {
    KanchuProjectCard(project: createExampleProject())
        .environmentObject(KanchuHomeView.ViewModel(container: .preview))
}
