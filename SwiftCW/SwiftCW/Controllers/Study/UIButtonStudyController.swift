//
//  UIButtonStudyController.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/21.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class UIButtonStudyController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button:UIButton = UIButton(type: UIButtonType.contactAdd)
        button.frame  = CGRect.init(x: 100, y: 80, width: 50, height: 20)
        button.backgroundColor = UIColor.lightGray
        view.addSubview(button)
        
//        button.addTarget(self, action: #selector(test1), for: UIControlEvents.touchUpInside)
        button.addTarget(self, action: #selector(test2(param1:)), for: UIControlEvents.touchUpInside)
    }
// MARK: 不带参 函数
    func test1(){
        print("test1")
    }
// MARK: 带参 函数
    func test2(param1:UIButton?){
        print("test2")
    }


}
