//
//  KanchuIntroView.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/18/25.
//

import SwiftUI

struct KanchuIntroView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                AoiText("AI가 만들어주는 나만의 맞춤 퀴즈!", font: .pretendardBold, size: 30)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
            
                AoiCard(
                    number: 1,
                    title: "AI 설정하기",
                    imageSource: "setting",
                    description: "사용하시는 AI 모델과 API 키를 설정하여 AI 퀴즈 기능을 활성화하세요.",
                    notice: "* API 키는 사용자가 발급하여야 합니다."
                )
                
                AoiCard(
                    number: 2,
                    title: "나만의 퀴즈 만들기",
                    imageSource: "quiz_setting",
                    description: "홈 화면의 '+' 버튼을 눌러 학습할 대상(학년, 단어장 등)과 문제 유형, 개수를 자유롭게 선택하고 '퀴즈 시작' 버튼을 누르세요."
                )
                
                AoiCard(
                    number: 3,
                    title: "AI가 만든 문제 풀기",
                    imageSource: "quiz_progress",
                    description: "AI가 당신의 설정에 맞춰 실시간으로 생성한 문제들을 풀어보며 실력을 점검해 보세요."
                )
                
                AoiCard(
                    number: 4,
                    title: "학습 결과 확인하기",
                    imageSource: "result",
                    description: "퀴즈가 끝나면 바로 점수를 확인하고, 오답 노트를 통해 어떤 문제를 틀렸는지 확인할 수 있습니다."
                )
                
                AoiCard(
                    number: 5,
                    title: "언제든지 다시 풀어보기",
                    imageSource: "home1",
                    description: "만들었던 퀴즈는 홈 화면에 저장되어 언제든지 다시 풀어볼 수 있습니다."
                )
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 50)
            .lineSpacing(7)
        }
        .frame(maxWidth: .infinity)
        .background(Color.primaryColor)
    }
}

#Preview {
    KanchuIntroView()
}
