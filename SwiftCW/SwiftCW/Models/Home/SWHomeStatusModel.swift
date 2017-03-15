//
//  SWHomeStatusModel.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/15.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class SWHomeStatusModel: NSObject {
    var attitudes_count : Int?
    var biz_feature : Int?
    var bmiddle_pic : String?
    var cardid : String?
    var comments_count : Int?
    var created_at : String?
    var darwin_tags : [AnyObject]?
    var favorited : Int?
    var geo : String?
    var gif_ids : String?
    var hasActionTypeCard : Int?
    var hot_weibo_tags : [AnyObject]?
    var id : Int?
    var idstr : String?
    
    var idsin_reply_to_screen_nametr : String?
    var in_reply_to_status_id : String?
    var in_reply_to_user_id : String?
    var isLongText : Bool?
    var is_show_bulletin : Int?
    var mid : Int?
    var mlevel : Int?
    var mlevelSource : String?
    var original_pic : String?
    var page_type : Int?
    var pic_urls : [String:String]?
    var positive_recom_flag : Int?
    var reposts_count : Int?
    var rid : String?
    var source : String?
    var source_allowclick : Bool?
    var source_type : Int?
    var text : String?
    var textLength : Int?
    var text_tag_tips : [AnyObject]?
    var thumbnail_pic : NSDictionary?
    var truncated : Int?
    var userType : Int?
    override init(){
        super.init()
    }

}
