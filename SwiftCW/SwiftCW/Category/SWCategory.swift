//
//  SWCategory.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/19.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

extension String{
    /**
     将当前字符串拼接到cache目录后面
     */
    func cacheDir() -> String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到doc目录后面
     */
    func docDir() -> String
    {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!  as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    /**
     将当前字符串拼接到tmp目录后面
     */
    func tmpDir() -> String
    {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }
    
    func subrange(start:Int,end:Int) -> String{
        let start = self.index(self.startIndex, offsetBy: start)
        let end = self.index(self.startIndex, offsetBy: end)
        let str = self.substring(with: Range(uncheckedBounds: (start,end)))
        return str
    }

}
extension Array{
    
    mutating func replaceObject(Index:Int,newObject:Element){
        let arrRange = Range.init(uncheckedBounds: (Index,Index + 1 ))
        self.replaceSubrange(arrRange, with: [newObject])
    }
}
