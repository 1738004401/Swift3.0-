//
//  GlobalConst.swift
//  Swift实战
//
//  Created by YiXue on 17/3/14.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import Foundation


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




