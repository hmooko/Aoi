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
        }
    }
}

#Preview {
    UserView()
        .environmentObject(Router())
        .environmentObject(DIContainer())
}
