//
//  BackupPicker.swift
//  LearningKanji
//
//  Created by koohyunmo on 6/26/25.
//

import SwiftUI

struct BackupPicker: View {
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack {
            Button {
                container.iCloudBookmarksUseCase().backup()
            } label: {
                Text("iCloud 백업")
            }
        }
    }
}

#Preview {
    BackupPicker()
}
