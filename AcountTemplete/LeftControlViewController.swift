//
//  LeftControlViewController.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/25.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import Eureka
class LeftControlViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< LabelRow().cellSetup({
                cell,row in
                cell.textLabel?.font = UIUtils.commonFont(size: 20)
                row.title = ""
            })

    }
    

    

}
