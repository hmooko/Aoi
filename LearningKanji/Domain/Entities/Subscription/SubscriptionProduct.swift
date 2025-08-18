//
//  SubscriptionProduct.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/15/25.
//

import Foundation

/// 비즈니스 로직에서 사용할 구독 상품 모델입니다.
struct SubscriptionProduct: Identifiable, Equatable {
    static func == (lhs: SubscriptionProduct, rhs: SubscriptionProduct) -> Bool {
        lhs.id == rhs.id
    }
    
    /// 상품의 고유 ID (예: "com.yourapp.pro.monthly")
    let id: String
    
    /// 사용자에게 보여줄 상품 이름
    let displayName: String
    
    /// 현재 지역에 맞춰 형식화된 가격 문자열
    let displayPrice: String
    
    /// 상품 설명
    let description: String
    
    /// 데이터 계층에서 사용하는 실제 StoreKit Product 객체를 저장하기 위한 래퍼.
    /// 도메인 계층은 이 속성의 구체적인 타입을 알지 못합니다.
    let underlyingProduct: Any
}
