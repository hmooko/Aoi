//
//  PayWallView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import SwiftUI

struct PayWallView: View {
    
    @EnvironmentObject var viewModel: KanchuHomeView.ViewModel
    @State private var introPresented: Bool = false
    
    var body: some View {
        VStack {
            Image("Aoi")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 50, trailing: 0))
            
            Text("AI를 이용하여 현재 학습하고 있는 한자로 문제를 만들어보세요")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            if viewModel.isKanchuMonthlyIntroductoryOffer {
                Text("* 신규 회원이라면 첫 한달은 무료로 이용 가능하며 그 후에는 자동으로 결제됩니다!")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 70, trailing: 0))
            }
            
            HStack {
                Button {
                    viewModel.purchaseKanchuMonthlyProduct()
                } label: {
                    AoiText("구독하기", font: .pretendardBold, size: 18)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primaryColor)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                }
                .buttonStyle(ScaleButtonStyle())
                
                Button {
                    viewModel.restorePurchases()
                } label: {
                    AoiText("복원하기", font: .pretendardBold, size: 18)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primaryColor)
                        }
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.horizontal)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            
            Button {
                introPresented = true
            } label: {
                AoiText("먼저 이 정보를 확인해주세요!", font: .pretendardBold, size: 18)
                    .foregroundStyle(Color.primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.tertiary)
                    }
                    .padding(.horizontal)
            }
            .buttonStyle(ScaleButtonStyle())
            .sheet(isPresented: $introPresented) {
                KanchuIntroView()
            }
        }
        .frame(maxHeight: .infinity)
        .padding()
        .background(.white)
    }
}

#Preview {
    PayWallView()
        .environmentObject(KanchuHomeView.ViewModel(container: .preview))
}
