//
//  SWHomeStatusBiz.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/19.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class SWHomeStatusBiz: NSObject {
    /**获取请求参数*/
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
    /**字典转模型*/
    class func getStatuses(json:Any) -> [SWHomeStatusModel] {
        let dict : [String:AnyObject] = json as! [String : AnyObject]
        let temps : [[String:AnyObject]] = dict["statuses"] as! [[String:AnyObject]]
        //缓存到数据库
        DAOManager.cacheStatuses(statuses: temps)
        
        let statues:[SWHomeStatusModel] = SWHomeStatusModel.mj_objectArray(withKeyValuesArray: temps).copy() as! [SWHomeStatusModel]
        return statues
    }
    
    /**刷新成功，model转layout*/
    class func getStatusLayout(refresh:RefreshType,originLayouts:[SWHomeLayoutModel],beAddStatusModeles:[SWHomeStatusModel]) -> [SWHomeLayoutModel]
    {
        var tempLayouts:[SWHomeLayoutModel] = []
        for statue in beAddStatusModeles{
            let layout = SWHomeLayoutModel.init(status: statue )
            tempLayouts.append(layout)
            
        }
        
        
//        var temp:NSMutableArray = NSMutableArray.init(array: originLayouts)
        var temp:[SWHomeLayoutModel] = [SWHomeLayoutModel]()
        temp += originLayouts
        if refresh == RefreshType.refreshTypeTop{
//            let insertRange:Range = Range.init(uncheckedBounds: (0,tempLayouts.count))
//            let insertIndexSet:IndexSet = IndexSet.init(integersIn: insertRange)
//            
//            
//            temp.insert(tempLayouts as![Any], at: insertIndexSet)
            temp.insert(contentsOf: tempLayouts, at: 0)
        }else{
//            temp.addObjects(from: tempLayouts as![Any])
            temp.append(contentsOf: tempLayouts)
        }
        return temp ;

    }
    //传入参数，原来的layoutmodel
    class func getLayoutModel(refresh:RefreshType,params:SWHomeStatuesParams,originLayouts:[SWHomeLayoutModel],completeBlock:@escaping ([SWHomeLayoutModel]) -> Void)
    {
        
        
        self.getStatusesFromSqlite(params: params) { (array) in//数据库获取
            
            if array == nil {//网络请求
                
                SWHttpManager.requestWeiboTimeline(apath: "https://api.weibo.com/2/statuses/home_timeline.json", params: params, block: { (json, error) in
                    if error == nil {
                        
                        let statues = SWHomeStatusBiz.getStatuses(json: json!)
                        completeBlock(SWHomeStatusBiz.getStatusLayout(refresh:refresh, originLayouts: originLayouts, beAddStatusModeles: statues ))
                    }
                    
                })
                
                
            }else{//数据库
                
                completeBlock(SWHomeStatusBiz.getStatusLayout(refresh:refresh, originLayouts: originLayouts, beAddStatusModeles: array!) )
            }
            
            
            
        }
        

}
    
//MARK 持久层相关
    
    /**
     *清空数据库
     */
    class func cleanStatusFromSqlite(){
        DAOManager.cleanStatuses()
    }
    
    /**
     *从sqlite中获取展现层model
     */
    class func getStatusesFromSqlite(params:SWHomeStatuesParams, finished: @escaping ([SWHomeStatusModel]?)->()){
        var since_id:Int?
        var max_id:Int?
        
        if params.since_id != nil{
            since_id = Int(params.since_id!)
        }
        
        if params.max_id != nil{
            max_id = Int(params.max_id!)
        }
        
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
