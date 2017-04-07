//
//  SWHomeStatusModel.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/15.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class SWHomeStatusModel: NSObject {
    var attitudes_count : Int64?
    var biz_feature : Int64?
    var bmiddle_pic : String?
    var cardid : String?
    var comments_count : Int64?
    var created_at : String!
    var created_at_local:Date?{
        get{
            let dateStr:String = self.created_at
            
            
            let formatter = DateFormatter()
            
            // 2.设置时间的格式
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
            
            // 3. 设置时间的区域(真机必须设置，否则可能不会转换成功)
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
            
            // 4.转换(转换好的时间是去除时区的时间)
            let createdDate = formatter.date(from: dateStr)!
            return createdDate
        }
    }
    var darwin_tags : [AnyObject]?
    var favorited : Int64?
    var geo : String?
    var gif_ids : String?
    var hasActionTypeCard : Int64?
    var hot_weibo_tags : [AnyObject]?
    var ID : String?
    var idstr : String?
    
    var idsin_reply_to_screen_nametr : String?
    var in_reply_to_status_id : String?
    var in_reply_to_user_id : String?
    var isLongText : Bool?
    var is_show_bulletin : Int64?
    var mid : Int64?
    var mlevel : Int64?
    var mlevelSource : String?
    var original_pic : String?
    var page_type : Int64?
    var pic_urls : NSArray?
    var positive_recom_flag : Int64?
    var reposts_count : Int64?
    var rid : String?
    var source : NSString?
    var source_allowclick : Int64?
    var source_type : Int64?
    var text : NSString?
    var textLength : Int64?
    var text_tag_tips : [AnyObject]?
    var thumbnail_pic : NSDictionary?
    var truncated : Int64?
    var userType : Int64?
    var user : SWStautsUser?
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id"]
    }
    override init(){
        super.init()
    }

}
