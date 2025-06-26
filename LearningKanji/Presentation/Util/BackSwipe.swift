//
//  BackSwipe.swift
//  LearningKanji
//
//  Created by koohyunmo on 9/5/24.
//

import Foundation
import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
