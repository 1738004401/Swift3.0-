//
//  BiBaoController.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/22.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
//MARK: 全局练习
typealias globalBlock1 = () -> Void
typealias globalBlock2 = () -> ()
typealias globalBlock3 = (String) -> Void
typealias globalBlock4 = () -> String
typealias globalBlock5 = (String) -> String

class BiBaoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//MARK: 常量练习
        var constBlock1 = {
            () -> Void in
        }
        
        var constBlock2 = {
            
        }
        var constBlock3 = {
            (a:String) -> Void in
        }
        
        var constBlock4 = {
            (a:String) -> String in
            return ""
        }
        
//Mark:函数参数练习
        func funcBlock1(a:() -> ()){
            
        }
        
        func funcBlock2(a:(String) -> ()){
            
        }
        func funcBlock3(a:(String) -> (String)){
            
        }
//MARK:逃逸闭包
        func funcBlock4(a:@escaping () -> ()){
            DispatchQueue.main.asyncAfter(deadline: .now()) { 
                a()
            }
            
            return
        }


    }

   
}
