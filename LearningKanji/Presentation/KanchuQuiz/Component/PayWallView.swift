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
        ScrollView {
            VStack(spacing: 30) {
                Image("AoiIcon")
                    .resizable()
                    .frame(width: 170, height: 170)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .rotationEffect(.degrees(-15))
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 30, trailing: 0))
                    .shadow(color: Color("shadow"), radius: 20, y: 4)
                    
                
                Text("AI를 이용하여 문제를 만들어보세요!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                //if viewModel.isKanchuMonthlyIntroductoryOffer {
                Text("신규 회원이라면 1개월 무료체험 이후 ₩2900/월 자동결제")
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                //}
                VStack {
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
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    Button {
                        viewModel.restorePurchases()
                    } label: {
                        AoiText("구독복원", font: .pretendardBold, size: 18)
                            .foregroundStyle(Color.primaryColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.tertiaryColor)
                            }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                
                Text("월간정기결제이며 구독 시 해당 [이용약관](https://www.apple.com/legal/internet-services/itunes/dev/stdeula)과 [개인정보처리방침](https://selective-wave-059.notion.site/Privacy-Policy-2ac5fcc47902481ab0384094f67a7474?source=copy_link)이 적용됩니다.")
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .padding(.vertical, 30)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
            }
            .padding().padding()
            
//            Button {
//                introPresented = true
//            } label: {
//                AoiText("먼저 이 정보를 확인해주세요!", font: .pretendardBold, size: 18)
//                    .foregroundStyle(Color.primaryColor)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 16)
//                            .fill(Color.tertiary)
//                    }
//                    .padding(.horizontal)
//            }
//            .buttonStyle(ScaleButtonStyle())
//            .sheet(isPresented: $introPresented) {
//                KanchuIntroView()
//            }
            
            KanchuIntroView()
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(Color.primaryColor)
    }
}

#Preview {
    PayWallView()
        .environmentObject(KanchuHomeView.ViewModel(container: .preview))
}
