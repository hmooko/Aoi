//
//  SwipeAction.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/15/24.
//

import Foundation
import SwiftUI

protocol SwipeAction {
    associatedtype SwipeActions: View
    @ViewBuilder func swipeAction() -> SwipeActions
}

struct SwipeNoWay: SwipeAction {
    func swipeAction() -> some View {
        return EmptyView()
    }
}

struct LearningByGradeSwipeAction: SwipeAction {
    let kanji: Kanji
    
    func swipeAction() -> some View {
        Button {
           
        } label: {
            Image(systemName: "bookmark")
        }.tint(Color("primary"))
        
    }
}

struct LearningBookmarksSwipeAction: SwipeAction {
    func swipeAction() -> some View {
        Button {
            
        } label: {
            Image(systemName: "trash")
        }.tint(.red)
        
    }
}
