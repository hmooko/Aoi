//
//  ContentViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/1/25.
//

import Foundation

extension ContentView {
    final class ViewModel: ObservableObject {
        let container: DIContainer
        @Published var isAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        init(container: DIContainer) {
            self.container = container
            BackingUp()
            LoadingBackup()
        }
        
        private func BackingUp() {
            if container.iCloudBookmarksUseCase().getIsBackingUp() {
                container.iCloudBookmarksUseCase().setIsBackingUP(false)
                isAlert = true
                alertTitle = "iCloud 백업이 중단되었습니다."
                alertMessage = "iCloud 백업 중 문제가 발생했습니다. 일부 데이터가 저장되지 않았을 수 있습니다. 다시 시도해주십시오."
            }
        }
        
        private func LoadingBackup() {
            if container.iCloudBookmarksUseCase().getIsLoadingBackup() {
                container.iCloudBookmarksUseCase().setIsLoadingBackup(false)
                isAlert = true
                alertTitle = "iCloud 불러오기가 중단되었습니다."
                alertMessage = "iCloud에서 데이터를 불러오는 중 문제가 발생했습니다. 일부 데이터가 복원되지 않았을 수 있습니다. 다시 시도해주십시오."
            }
        }
    }
}
