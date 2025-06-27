//
//  BackupPicker.swift
//  LearningKanji
//
//  Created by koohyunmo on 6/26/25.
//

import SwiftUI

struct BackupPicker: View {
    @EnvironmentObject var container: DIContainer
    @State var isBackingUP = false
    @State var isAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        VStack {
            List {
                Section {
                    Button {
                        isBackingUP = true
                        DispatchQueue.global().async {
                            container.iCloudBookmarksUseCase().backup() { error in
                                if let error = error {
                                    
                                    print(error)
                                    isBackingUP = false
                                    isAlert = true
                                    alertTitle = "백업 실패"
                                    alertMessage = "apple 계정에 문제가 있는 지 확인해 주세요."
                                    return
                                }
                                
                                isBackingUP = false
                                isAlert = true
                                alertTitle = "백업 성공"
                                alertMessage = "iCloud에 백업되었습니다."
                            }
                        }
                    } label: {
                        HStack {
                            Text("iCloud 백업")
                                .pretendardMedium(size: 18)
                            Spacer()
                            
                            if isBackingUP {
                                Text("백업 중...")
                                    .pretendardMedium(size: 18)
                                ProgressView()
                            }
                        }
                        
                    }
                } footer: {
                    VStack(alignment: .leading) {
                        Text("")
                        Text("백업 작업을 한 후에는 이전의 백업 데이터들은 삭제되니 주의해 주세요.")
                        Text("백업 작업에 소요되는 시간은 백업되는 데이터 크기에 따라 차이가 날 수 있습니다.")
                    }
                }
            }
            .disabled(isBackingUP)
            .alert(alertTitle, isPresented: $isAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            
        }
    }
}

#Preview {
    BackupPicker()
}
