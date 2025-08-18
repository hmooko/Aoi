//
//  SubscriptionStatus.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

/// 사용자의 현재 구독 상태를 나타내는 모델입니다.
enum SubscriptionStatus {
    /// 프리미엄 기능에 접근할 수 있는 유료 사용자
    case paidKanchuMonthly
    
    /// 무료 사용자
    case free
    
    func description() -> String {
        switch self {
        case .paidKanchuMonthly:
            return "paidKanchuMonthly"
        case .free:
            return "free"
        }
    }
}
