//
//  UserDefaultExt.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/20.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
extension DefaultsKeys {
    static let username = DefaultsKey<String?>("username")
    static let password = DefaultsKey<String?>("password")
    static let phoneNumber = DefaultsKey<String?>("phoneNumber")
    static let avatar = DefaultsKey<String?>("avatar")
    static let token = DefaultsKey<String?>("token")
    
}
