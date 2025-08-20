//
//  ContentViewModel.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/1/25.
//

import Foundation

extension ContentView {
    @MainActor
    final class ViewModel: ObservableObject {
        let container: DIContainer
        @Published var isAlert = false
        @Published var alertTitle = ""
        @Published var alertMessage = ""
        
        private let iCloudGlobalBackupUseCase: ICloudGlobalBackupUseCase
        
        init(container: DIContainer) {
            self.container = container
            self.iCloudGlobalBackupUseCase = container.iCloudGlobalBackupUseCase()
            isBackingUp()
            isLoading()
        }
        
        private func isBackingUp() {
            if iCloudGlobalBackupUseCase.getIsBackingUp() {
                iCloudGlobalBackupUseCase.setIsBackingUp(false)
                isAlert = true
                alertTitle = "iCloud 백업이 중단되었습니다."
                alertMessage = "iCloud 백업 중 문제가 발생했습니다. 일부 데이터가 저장되지 않았을 수 있습니다. 다시 시도해주십시오."
            }
        }
        
        private func isLoading() {
            if iCloudGlobalBackupUseCase.getIsLoading() {
                iCloudGlobalBackupUseCase.setIsLoading(false)
                isAlert = true
                alertTitle = "iCloud 불러오기가 중단되었습니다."
                alertMessage = "iCloud에서 데이터를 불러오는 중 문제가 발생했습니다. 일부 데이터가 복원되지 않았을 수 있습니다. 다시 시도해주십시오."
            }
        }
    }
}
