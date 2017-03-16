//
//  GlobalConst.swift
//  Swift实战
//
//  Created by YiXue on 17/3/14.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import Foundation
import YYKit


/**
 *  设备尺寸相关
 */
let kScreen_Bounds = UIScreen.main.bounds
let kScreen_Height = UIScreen.main.bounds.height
let kScreen_Width  = UIScreen.main.bounds.width
let kScreen_Width_Scale = (kScreen_Width > 320 ? kScreen_Width/320 : 1.0)
let kStatusBar_Height = 20.0
let kNavgation_Height = 44.0
let kNavgation_Status_Height = 64.0
let kTabbar_Height = 49.0

/**
 * 上拉 下拉类型
 */

enum RefreshType : Int{
    case refreshTypeTop
    case refreshTypeBottom
}

/*
 * APPKey
 **/
let WB_App_Key = "2490216176"
let WB_App_Secret = "b3e28c7a394b36fec565253244e0dffc"
let WB_redirect_uri = "http://www.520it.com"

/*UserDefault **/

let SWUserJson = "SWUserJson"

// 颜色
let kWBCellTextNormalColor:UIColor =  UIColor.init(hexString:"333333")!
let kWBCellTextSubTitleColor:UIColor =  UIColor.init(hexString:"5d5d5d")!
let kWBCellTextHighlightColor:UIColor =  UIColor.init(hexString:"527ead")!
let kWBCellTextHighlightBackgroundColor:UIColor =  UIColor.init(hexString:"bfdffe")!
let kWBCellBackgroundColor:UIColor = UIColor.init(hexString:"f2f2f2")!    // Cell背景灰色
let kWBCellHighlightColor:UIColor = UIColor.init(hexString:"f0f0f0")!     // Cell高亮时灰色
let kWBCellInnerViewColor:UIColor = UIColor.init(hexString:"f7f7f7")!   // Cell内部卡片灰色

let kWBCellPadding:CGFloat = 10.0





