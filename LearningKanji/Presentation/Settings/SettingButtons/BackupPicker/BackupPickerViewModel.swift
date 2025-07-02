//
//  BackupPickerViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/1/25.
//

import Foundation
import SwiftUI

extension BackupPicker {
    final class ViewModel: ObservableObject {
        let container: DIContainer
        @Published var isBackingUP = false
        
        @Published var isLoadingBackup = false
        
        @Published var isAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        init(container: DIContainer) {
            self.container = container
        }
        
        func syncBackupStatus() {
            isBackingUP = container.iCloudBookmarksUseCase().getIsBackingUp()
            isLoadingBackup = container.iCloudBookmarksUseCase().getIsLoadingBackup()
        }
        
        func backup() {
            isBackingUP = true
            Task {
                do {
                    try await container.iCloudBookmarksUseCase().backup()
                    await MainActor.run {
                        isBackingUP = false
                        isAlert = true
                        alertTitle = "백업 성공"
                        alertMessage = "iCloud에 백업되었습니다."
                    }
                } catch {
                    print(error)
                    await MainActor.run {
                        isBackingUP = false
                        isAlert = true
                        alertTitle = "백업 실패"
                        alertMessage = "apple 계정에 문제가 있는 지 확인해 주세요."
                    }
                }
            }
        }
        
        func load() {
            isLoadingBackup = true
            Task {
                do {
                    try await container.iCloudBookmarksUseCase().load()
                    await MainActor.run {
                        isLoadingBackup = false
                        isAlert = true
                        alertTitle = "불러오기 성공"
                        alertMessage = "백업 데이터를 불러왔습니다."
                    }
                } catch {
                    print(error)
                    await MainActor.run {
                        isBackingUP = false
                        isAlert = true
                        alertTitle = "불러오기 실패"
                        alertMessage = "apple 계정에 문제가 있는 지 확인해 주세요."
                    }
                }
            }
        }
    }
}
