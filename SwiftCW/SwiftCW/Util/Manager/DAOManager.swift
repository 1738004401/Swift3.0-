//
//  DAOManager.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/19.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import FMDB

class DAOManager: NSObject {

    private static let manager:DAOManager = DAOManager()
    var dbQueue: FMDatabaseQueue?
    
    class func shareManager() -> DAOManager!{
        return manager
    }

    func openDB(DBName: String)
    {
        // 1.根据传入的数据库名称拼接数据库路径
        let path = DBName.docDir()
        print(path)
        
        // 2.创建数据库对象
        // 注意: 如果是使用FMDatabaseQueue创建数据库对象, 那么就不用打开数据库
        dbQueue = FMDatabaseQueue(path: path)
        
        
        // 4.创建表
        creatTable()
    }
    private func creatTable()
    {
        // 1.编写SQL语句
        let sql = "CREATE TABLE IF NOT EXISTS T_Status( \n" +
            "statusId INTEGER PRIMARY KEY, \n" +
            "statusText TEXT, \n" +
            "userId INTEGER, \n" +
            "createDate TEXT NOT NULL DEFAULT (datetime('now', 'localtime')) \n" +
        "); \n"
        
        // 2.执行SQL语句
        dbQueue!.inDatabase { (db) -> Void in
            db?.executeUpdate(sql, withArgumentsIn: nil)
        }
    }


    /// 清空过期的数据
    class  func cleanStatuses() {
        
        //        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        
        let date = NSDate(timeIntervalSinceNow: -60)
        let dateStr = formatter.string(from: date as Date)
        //        print(dateStr)
        
        // 1.定义SQL语句
        let sql = "DELETE FROM T_Status WHERE createDate  <= '\(dateStr)';"
        
        // 2.执行SQL语句
        DAOManager.shareManager().dbQueue?.inDatabase({ (db) -> Void in
            db?.executeUpdate(sql, withArgumentsIn: nil)
        })
    }
    
//    /// 加载微博数据
//    class  func loadStatuses(since_id: Int, max_id: Int, finished: @escaping ([[String: AnyObject]]?, _ error: NSError?)->()) {
//        
//        // 1.从本地数据库中获取
//        loadCacheStatuses(since_id: since_id, max_id: max_id) { (array) -> () in
//            
//            // 2.如果本地有, 直接返回
//            if !array!.isEmpty
//            {
//                print("从数据库中获取")
//                finished(array, nil)
//                return
//            }
//            
//            
//            
//            
//        }
//        
//    }
//    
    /// 从数据库中加载缓存数据
    class func loadCacheStatuses(since_id: Int, max_id: Int, finished: @escaping ([[String: AnyObject]]?)->()) {
        
        // 1.定义SQL语句
        var sql = "SELECT * FROM T_Status \n"
        if since_id > 0
        {
            sql += "WHERE statusId > \(since_id) \n"
        }else if max_id > 0
        {
            sql += "WHERE statusId < \(max_id) \n"
        }
        
        sql += "ORDER BY statusId DESC \n"
        sql += "LIMIT 20; \n"
        
        // 2.执行SQL语句
        DAOManager.shareManager().dbQueue?.inDatabase({ (db) -> Void in
            
            // 2.1查询数据
            // 返回字典数组的原因:通过网络获取返回的也是字典数组,
            // 让本地和网络返回的数据类型保持一致, 以便于我们后期处理
            var statuses = [[String: AnyObject]]()
            
            if let res =  db?.executeQuery(sql, withArgumentsIn: nil)
            {
                // 2.2遍历取出查询到的数据
                while res.next()
                {
                    // 1.取出数据库存储的一条微博字符串
                    let dictStr = res.string(forColumn: "statusText") as String
                    // 2.将微博字符串转换为微博字典
                    let data = dictStr.data(using: String.Encoding.utf8)!
                    let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    statuses.append(dict)
                }
                
                
            }
            
            // 3.返回数据
            finished(statuses)
            
        })
    }
    
    /// 缓存微博数据
    class func cacheStatuses(statuses: [[String: AnyObject]])
    {
        
        // 0. 准备数据
        let userId:String! = SWUser.curUser()?.uid!
        
        // 1.定义SQL语句
        let sql = "INSERT OR REPLACE INTO T_Status" +
            "(statusId, statusText, userId)" +
            "VALUES" +
        "(?, ?, ?);"
        
        // 2.执行SQL语句
        DAOManager.shareManager().dbQueue?.inTransaction({ (db, rollback) -> Void in
            
            for dict in statuses
            {
                let statusId = dict["id"]!
                // JSON -> 二进制 -> 字符串
                let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let statusText = String(data: data, encoding: String.Encoding.utf8)!
                if !(db?.executeUpdate(sql, withArgumentsIn: [statusId, statusText, userId]))!
                {
//                    rollback?.advanced(by: 1)
                }
                
            }
        })
    }

    
    
    
}
