//
//  AppNavigationController.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/24.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import Material

class AppNavigationController:NavigationController{
    open override func prepare() {
        super.prepare()
        isMotionEnabled = true
        motionNavigationTransitionType = .slide(direction: .down)
    }
}
