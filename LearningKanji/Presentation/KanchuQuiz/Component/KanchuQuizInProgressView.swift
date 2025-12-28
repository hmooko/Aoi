//
//  KanchuQuizInProgressView.swift
//  LearningKanji
//
//  Created by koohyunmo on 7/9/25.
//

import SwiftUI

// SwiftUI 레이아웃 시스템과 더 잘 호환되도록 UITextView를 상속하는 커스텀 클래스입니다.
// 콘텐츠의 크기를 정확하게 계산하여 SwiftUI에게 알려주는 역할을 합니다.
class ContentSizedTextView: UITextView {
    override var bounds: CGRect {
        didSet {
            // 뷰의 경계(특히 너비)가 변경될 때마다 크기를 다시 계산하도록 신호를 보냅니다.
            if bounds.size != oldValue.size {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        // 현재 너비에 맞춰 콘텐츠를 표시하는 데 필요한 실제 크기를 계산하여 반환합니다.
        let newSize = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
        return newSize
    }
}


struct TextViewWrapper: UIViewRepresentable {
    // text와 attributedText를 모두 처리할 수 있도록 수정합니다.
    var text: String? = nil
    var attributedText: NSAttributedString? = nil
    
    var textAlignment: NSTextAlignment
    var font: UIFont?

    func makeUIView(context: Context) -> UITextView {
        // 일반 UITextView 대신 커스텀 클래스를 사용합니다.
        let textView = ContentSizedTextView()
        textView.isEditable = false
        textView.isSelectable = true
        
        // 스크롤을 비활성화하여 콘텐츠 크기에 맞게 뷰 크기가 조절되도록 합니다.
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        // UITextView 내부의 기본 패딩을 제거합니다.
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        // 우선순위 설정은 그대로 유지하여 레이아웃 안정성을 높입니다.
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        if let attributedText = attributedText {
            textView.attributedText = attributedText
        } else if let text = text {
            textView.text = text
            textView.font = font
        }
        
        textView.textAlignment = textAlignment
        
        // 텍스트가 업데이트된 후에도 크기를 다시 계산하도록 합니다.
        textView.invalidateIntrinsicContentSize()
    }
    
    // 텍스트가 편집되지 않으므로 Coordinator는 더 이상 필요하지 않습니다.
}

struct KanchuQuizInProgressView: View {
    @EnvironmentObject var viewModel: KanchuQuizView.ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let problem = viewModel.currentProblem {
                // 진행 바
                ProgressView(value: Double(viewModel.currentProblemIndex + 1), total: Double(viewModel.problems.count))
                    .progressViewStyle(.linear)
                    .animation(.linear, value: viewModel.currentProblemIndex)
                
                HStack {
                    Text("문제 \(viewModel.currentProblemIndex + 1)/\(viewModel.problems.count)")
                    Spacer()
                    Text(problem.type.rawValue)
                        .font(.caption)
                        .padding(6)
                        .background(Color.yellow.opacity(0.3))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                if viewModel.currentProblem?.type == .fillReading {
                    TextViewWrapper(
                        text: "\(viewModel.currentProblem?.targetWord ?? ""): ",
                        textAlignment: .center,
                        font: UIFont(name: "Pretendard-Medium", size: 20)
                    )
                    .fixedSize(horizontal: false, vertical: true) // 뷰가 콘텐츠 크기에 맞게 조절되도록 함
                }

                // 문제 예문
                problemSentenceView(sentence: problem.sentence, target: problem.targetWord)
                
                Spacer()
                
                // 선택지
                VStack(spacing: 12) {
                    ForEach(problem.options, id: \.self) { choice in
                        Button(action: {
                            viewModel.submitAnswer(for: choice)
                        }) {
                            Text(choice)
                                .font(.title2)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(buttonTint(for: choice))
                        .disabled(viewModel.isAnswered)
                    }
                }
                
                Spacer()
                
            } else {
                Text("문제를 불러오는 중입니다...") // AoiText 대신 표준 Text 사용
            }
        }
        .padding()
    }
    
    private func problemSentenceView(sentence: String, target: String) -> some View {
        // NSAttributedString을 생성하여 텍스트의 부분별 스타일을 적용합니다.
        let attributedString = NSMutableAttributedString()
        
        // SwiftUI의 .largeTitle 폰트와 유사하게 UIKit 폰트를 설정합니다.
        let baseFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        let baseAttributes: [NSAttributedString.Key: Any] = [.font: baseFont, .foregroundColor: UIColor.label]
        let highlightedAttributes: [NSAttributedString.Key: Any] = [.font: baseFont, .foregroundColor: UIColor.systemBlue]

        var current = ""
        var isInside = false
        for char in sentence {
            if char == "(" {
                if !current.isEmpty {
                    attributedString.append(NSAttributedString(string: current, attributes: baseAttributes))
                    current = ""
                }
                isInside = true
            } else if char == ")" {
                if !current.isEmpty {
                    attributedString.append(NSAttributedString(string: current, attributes: highlightedAttributes))
                    current = ""
                }
                isInside = false
            } else if char == "_" {
                if !current.isEmpty {
                    let attributes = isInside ? highlightedAttributes : baseAttributes
                    attributedString.append(NSAttributedString(string: current, attributes: attributes))
                    current = ""
                }
                attributedString.append(NSAttributedString(string: String(char), attributes: highlightedAttributes))
            } else {
                current.append(char)
            }
        }
        if !current.isEmpty {
            let attributes = isInside ? highlightedAttributes : baseAttributes
            attributedString.append(NSAttributedString(string: current, attributes: attributes))
        }
        
        // TextViewWrapper를 사용하여 NSAttributedString을 보여줍니다.
        return TextViewWrapper(
            attributedText: attributedString,
            textAlignment: .center
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private func buttonTint(for choice: String) -> Color {
        guard viewModel.isAnswered else { return .black }
        
        if choice == viewModel.currentProblem?.answer {
            return .green
        } else if choice == viewModel.selectedChoice {
            return .red
        } else {
            return .gray
        }
    }
}

#Preview {
    let container = DIContainer.preview
    let viewModel: KanchuQuizView.ViewModel = .init(container: container)
    viewModel.quizSettings.count = 5
    viewModel.quizSettings.target = .elementary(grade: .first)
    viewModel.quizSettings.problemType = .findReading
    viewModel.startQuiz()
    
    return KanchuQuizInProgressView()
        .environmentObject(viewModel)
}
