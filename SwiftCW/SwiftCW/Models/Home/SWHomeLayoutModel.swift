//
//  SWHomeLayoutModel.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/15.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class SWHomeLayoutModel: NSObject {
    public var statusModel : SWHomeStatusModel?
    
    
    init(status:SWHomeStatusModel) {
        super.init()
        statusModel = status
    }
    
    override init() {
        super.init()
    }
    
}
