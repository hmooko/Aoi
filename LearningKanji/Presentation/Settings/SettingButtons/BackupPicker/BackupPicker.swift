//
//  BackupPicker.swift
//  LearningKanji
//
//  Created by koohyunmo on 6/26/25.
//

import SwiftUI

struct BackupPicker: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            List {
                Section {
                    Button {
                        viewModel.backup()
                    } label: {
                        HStack {
                            Text("iCloud 백업")
                                .pretendardMedium(size: 18)
                            Spacer()
                            
                            if viewModel.isBackingUP {
                                Text("백업 중...")
                                    .pretendardMedium(size: 18)
                                ProgressView()
                            }
                        }
                        
                    }
                } footer: {
                    VStack(alignment: .leading) {
                        Text("")
                        Text("백업 작업 도중 앱을 종료하면 작업이 중단되어 데이터에 문제가 생길 수 있습니다.")
                        Text("백업 작업을 한 후에는 이전의 백업 데이터들은 삭제되니 주의해 주세요.")
                        Text("백업 작업에 소요되는 시간은 백업되는 데이터 크기에 따라 차이가 날 수 있습니다.")
                    }
                }
                
                Section {
                    Button {
                        viewModel.load()
                    } label: {
                        HStack {
                            Text("백업 불러오기")
                                .pretendardMedium(size: 18)
                            Spacer()
                            
                            if viewModel.isLoadingBackup {
                                Text("불러오는 중...")
                                    .pretendardMedium(size: 18)
                                ProgressView()
                            }
                        }
                    }
                } footer: {
                    VStack(alignment: .leading) {
                        Text("")
                        Text("불러오기 작업 도중 앱을 종료하면 작업이 중단되어 데이터에 문제가 생길 수 있습니다.")
                        Text("불러오기 작업을 한 후에는 이전의 로컬 데이터들은 삭제되니 주의해 주세요.")
                        Text("불러오기 작업에 소요되는 시간은 백업되는 데이터 크기에 따라 차이가 날 수 있습니다.")
                    }
                }
            }
            .disabled(viewModel.isLoadingBackup)
            .disabled(viewModel.isBackingUP)
            .alert(viewModel.alertTitle, isPresented: $viewModel.isAlert) {
                Button("확인", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
            .onAppear {
                viewModel.syncBackupStatus()
            }
            
            if viewModel.isLoadingBackup || viewModel.isBackingUP {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView(viewModel.isBackingUP ? "백업 중..." : "데이터를 불러오는 중...")
                    .multilineTextAlignment(.center)
                    .padding(32)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
                    .shadow(radius: 8)
            }
        }
        .interactiveDismissDisabled(viewModel.isLoadingBackup || viewModel.isBackingUP)
    }
}

#Preview {
    BackupPicker(viewModel: .init(container: DIContainer()))
}
