//
//  SWUser.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/15.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class SWUser: NSObject {

    var access_token : String?
    var expires_in : Int64?
    var remind_in : String?
    var uid : String?
    

    /*
     *是否登陆
     **/
    open class  func isLogin() -> Bool{
        
        return curUser()?.uid != nil
    }
    
    open class func curUser() -> SWUser?{
//        let dict : [String:Any?]? = UserDefaults.standard.dictionary(forKey: SWUserJson) as? [String:Any?]
        let dict : [String:Any?]? = UserDefaults.standard.dictionary(forKey: SWUserJson) 
        if dict?["uid"] != nil {
            let user = SWUser.init(dict: dict! )
            return user
        }
        
        return nil
    }
    override init(){
        
    }
    init(dict:[String:Any?]) {
        super.init()
        access_token = dict["access_token"]! as! String?
        expires_in = dict["expires_in"]! as! Int64?
        remind_in = dict["remind_in"]! as! String?
        uid = dict["uid"]! as! String?
    }

}
