//
//  SWHttpManager.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/19.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
//block 在此处可以做一些事情后再调用
class SWHttpManager: NSObject {

    public class func requestWeiboTimeline(apath:String,params:SWHomeStatuesParams?,block:@escaping requestResultBlock)
    {
        let timeline_params = params?.mj_keyValues()
        BaseHTTPMethodTool.shareInstance.requestJsonDataWithPath(aPath: apath, Params: timeline_params, MethodType: NetworkMethod.Get, block: block)
    }
}
