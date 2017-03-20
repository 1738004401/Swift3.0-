//
//  SWHomeStatusBiz.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/19.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class SWHomeStatusBiz: NSObject {
   class func getParams(refretype:RefreshType,statuses:[SWHomeLayoutModel]?) -> SWHomeStatuesParams {
    
        let params = SWHomeStatuesParams()
         params.access_token = SWUser.curUser()?.access_token!
        switch refretype {
        case RefreshType.refreshTypeTop:
            let since_id = statuses?.first?.statusModel.idstr ?? "0"
            
            
           
            params.since_id = since_id;

            return  params
            
            
        case RefreshType.refreshTypeBottom:
            let max_id = statuses?.last?.statusModel.ID ?? "0"
            params.max_id = max_id
            return params
            
        }
        
        
    }
    class func getStatuses(json:Any) -> NSMutableArray {
        let dict : [String:AnyObject] = json as! [String : AnyObject]
        let temps : [[String:AnyObject]] = dict["statuses"] as! [[String:AnyObject]]
        //缓存到数据库
        DAOManager.cacheStatuses(statuses: temps)
        
        let statues:NSMutableArray = SWHomeStatusModel.mj_objectArray(withKeyValuesArray: temps)
        return statues
    }
    class func getStatusLayout(refresh:RefreshType,originLayouts:[SWHomeLayoutModel],beAddStatusModeles:[SWHomeStatusModel]) -> [SWHomeLayoutModel]
    {
        var tempLayouts = NSMutableArray()
        for statue in beAddStatusModeles{
            let layout = SWHomeLayoutModel.init(status: statue as! SWHomeStatusModel)
            tempLayouts.add(layout)
        }
        
        
        var temp:NSMutableArray = NSMutableArray.init(array: originLayouts)
        if refresh == RefreshType.refreshTypeTop{
            let insertRange:Range = Range.init(uncheckedBounds: (0,tempLayouts.count))
            let insertIndexSet:IndexSet = IndexSet.init(integersIn: insertRange)
            
            temp.insert(tempLayouts as![Any], at: insertIndexSet)
        }else{
            temp.addObjects(from: tempLayouts as![Any])
        }
        return temp as! [SWHomeLayoutModel];

    }
    class func cleanStatusFromSqlite(){
        DAOManager.cleanStatuses()
    }
    class func getStatusesFromSqlite(params:SWHomeStatuesParams, finished: @escaping ([SWHomeStatusModel]?)->()){
        var since_id:Int?
        var max_id:Int?
        
        if params.since_id != nil{
            since_id = Int(params.since_id!)
        }
        
        if params.max_id != nil{
            max_id = Int(params.max_id!)
        }
        
        
//        let since_id:Int? = Int(dict["since_id"] as! String)
//        let max_id:Int? =   Int(dict["max_id"] as! String)
        DAOManager.loadCacheStatuses(since_id: since_id ?? 0, max_id: max_id ?? 0) { (array) in
            
            if !(array?.isEmpty)!{
                var statuesModels:[SWHomeStatusModel] = []
                
                for dict in array!{
                    let model = SWHomeStatusModel.mj_object(withKeyValues: dict)
                    statuesModels.append(model!)
                }
                finished(statuesModels)
                return
            }else{
                finished(nil)
            }
            
            
            
        }
    }
}
