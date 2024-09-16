//
//  AoiNavigationBar.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/16/24.
//

import Foundation
import SwiftUI
extension View {
    func aoiNavigationBar(router: Router) -> some View {
        self
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Aoi")
                        .pretendardMedium(size: 18)
                        .foregroundStyle(.white)
                }
                        
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.push(.settingScene)
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.white)
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                VStack { }
                    .frame(maxWidth: .infinity)
                    .background(Color("primary"))
            }
    }
    
    func aoiDefaultNavigationBar(router: Router) -> some View {
        self
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.white)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top) {
                VStack { }
                    .frame(maxWidth: .infinity)
                    .background(Color("primary"))
            }
            .navigationBarBackButtonHidden()
    }
}
