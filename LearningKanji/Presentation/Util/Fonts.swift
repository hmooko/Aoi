//
//  Fonts.swift
//  LearningKanji
//
//  Created by koohyunmo on 8/16/24.
//

import Foundation
import SwiftUI

extension View {
    func gmarketSansBold(size: CGFloat) -> some View {
        self.font(.custom("GmarketSansBold", size: size))
    }
    
    func gmarketSansLight(size: CGFloat) -> some View {
        self.font(.custom("GmarketSansLight", size: size))
    }
    
    func gmarketSansMedium(size: CGFloat) -> some View {
        self.font(.custom("GmarketSansMedium", size: size))
    }
    
    func pretendardFont(size: CGFloat) -> some View {
        self.font(.custom("Pretendard-Black", size: size))
    }
    
    func pretendardBold(size: CGFloat) -> some View {
        self.font(.custom("Pretendard-Bold", size: size))
    }
    
    func pretendardMedium(size: CGFloat) -> some View {
        self.font(.custom("Pretendard-Medium", size: size))
    }
    
    func pretendardLight(size: CGFloat) -> some View {
        self.font(.custom("Pretendard-Light", size: size))
    }
}
