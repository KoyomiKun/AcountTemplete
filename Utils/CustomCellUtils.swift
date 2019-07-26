//
//  CustomCellUtils.swift
//  AcountTemplete
//
//  Created by Wallance on 2019/7/25.
//  Copyright © 2019 Wallance. All rights reserved.
//

import UIKit
import Eureka
public class CustomCell: Cell<Bool>, CellType {
    public override func setup() {
        super.setup()
        
    }
    
    public override func update() {
       super.update()
    }
}

// 自定义的Row，拥有CustomCell和对应的value
public final class CustomRow: Row<CustomCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
        // 我们把对应CustomCell的 .xib 加载到cellProvidor
        cellProvider = CellProvider<CustomCell>(nibName: "CustomCell")
    }
}
