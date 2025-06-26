//
//  UserView.swift
//  LearningKanji
//
//  Created by koohyunmo on 5/15/25.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            Button {
                container.iCloudBookmarksUseCase().backup()
            } label: {
                Text("backup")
            }
            Button {
                print("실행")
                container.iCloudBookmarksUseCase().load()
            } label: {
                Text("synchronize")
            }
        }
    }
}

#Preview {
    UserView()
        .environmentObject(Router())
        .environmentObject(DIContainer())
}
