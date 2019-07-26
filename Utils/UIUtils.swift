//
//  UIUtils.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/19.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import TextFieldEffects
import SCLAlertView
class UIUtils {
    // TextFields
    public static func createTextField(withIdentify:String,_ fond:UIFont)->HoshiTextField{
        let textField = HoshiTextField()
        textField.font = fond
        textField.placeholder = withIdentify
        textField.placeholderColor = .darkGray
        textField.borderInactiveColor = .blue
        return textField
    }
    // Alert
    static let appearance = SCLAlertView.SCLAppearance(
        kTitleFont: commonFont(size: 20),
        kTextFont: commonFont(size: 14),
        kButtonFont: commonFont(size: 14),
        showCloseButton: false
    )
    // Font
    public static func commonFont(size:CGFloat)->UIFont{
        return UIFont(name: "Avenir Next Condensed", size: size)!
    }
   
}
