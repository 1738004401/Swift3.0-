//
//  BaseHTTPMethodTool.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/18.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import AFNetworking

enum  NetworkMethod:Int{
    case Get = 0
    case Post
    case Put
    case Delete
}
public typealias requestResultBlock = (_ json:Any?,_ error:NSError?) -> Void

final class BaseHTTPMethodTool: AFHTTPSessionManager {
    static let shareInstance = BaseHTTPMethodTool()
    
    public func requestJsonDataWithPath(aPath:String,Params:NSDictionary?,MethodType:NetworkMethod,block:@escaping requestResultBlock)
    {
        requestJsonDataWithPath(aPath: aPath, Params: Params, MethodType: MethodType, autoShowError: true, block: block)
    }
    public func requestJsonDataWithPath(aPath:String,Params:NSDictionary?,MethodType:NetworkMethod,autoShowError:Bool,block:@escaping requestResultBlock)
    {
        if aPath.isEmpty || aPath.characters.count <= 0{
            return
        }
        
//        aPath = aPath.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        switch MethodType {
        case .Get:
            
            get(aPath, parameters: Params, progress: { (progress) in
                print(progress)
                
            }, success: { (_, json) in
                block(json! ,nil)
            }, failure: { (_, error) in
//                block(nil,error)
            })
            break
        case .Post:
            
            post(aPath, parameters: Params, progress: { (_) in
                
            }, success: { (_, json) in
                block(json!,nil)
            }, failure: { (_, error) in
                print(error)
            })
            
            break
        case .Put:
            break
        case .Delete:
            break
        }
        
    }
    
    public func requestJsonDataWithPath(aPath:String,file:NSDictionary,withParams:NSDictionary,withMethodType:NetworkMethod,block:requestResultBlock)
    {
        
    }
    
    
//    public func uploadImage(image:UIImage,path:String,name:String,successBlock:NSDictionary,failureBlock:NetworkMethod,block:progerssBlock)
//    {
//        
//    }
//    
//    
//    
//    public func uploadImage:(UIImage *)image path:(NSString *)path name:(NSString *)name
//    successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//    failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//    progerssBlock:(void (^)(CGFloat progressValue))progress;
//    
//    public func uploadVoice:(NSString *)file
//    withPath:(NSString *)path
//    withParams:(NSDictionary*)params
//    andBlock:(void (^)(id data, NSError *error))block;

}
