//
//  ArrayDictStringController.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/22.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//
//MARK: `Swift` 提供了 `String` 和 `NSString` 之间的无缝转换
import UIKit

class ArrayDictStringController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        stringFunc()
        arrayFunc()
//        dictFunc()
        
    }
    func stringFunc(){
        //1.0 拼接
        let str1:String = "你是谁？"
        let str2:String = "我是XXX"
        let str3:String = str1 + str2
        print(str3)
        
        
        //2.0 格式化
        let str4:String = String.init(format: "%d--%f--%@", arguments: [3,3.0,"test"])
        print(str4)
        
        //3.0 截取
        
        let str5:String = "12345678"
        let str6 = str5.substring(from: str5.index(str5.startIndex, offsetBy: 5))
        let str7 = str5.substring(to: str5.index(str5.startIndex, offsetBy: 4))
        
        //代码有点恶心，太麻烦了 我写了个分类
        let start = str5.index(str5.startIndex, offsetBy: 2)
        let end = str5.index(str5.startIndex, offsetBy: 5)
        let str8 = str5.substring(with: Range(uncheckedBounds: (start,end)))
        print(str6)
        print(str7)
        print(str8)
        
        //分类
        let str9 = str5.subrange(start: 1, end: 6)
        print(str9)
        
        //汉字Url格式化
        let str10 = "我是XXX"
        let str11 = str10.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        print(str11 ?? "失败")
        
        
    }
    func arrayFunc(){
        
        //常规用法
        let arr1 = ["1","2","3","4"]
        print(arr1)
        
        //MARK:-可变数组
        var arr2:[String] = []
        //增删改查
        
        let arr3 = ["arr2"];
        arr2 = arr2 + arr3
        
        arr2.append("var-arr0")
        arr2.append("var-arr1")
        arr2.append("var-arr2")
        arr2.append("var-arr3")
        arr2.append("var-arr4")
        arr2.append("var-arr5")
        arr2.append("var-arr6")
        arr2.append("var-arr7")
        arr2.append("var-arr8")
        
        print(arr2)
        
        arr2.remove(at: 0)
        print(arr2)
        
        //这个感觉好麻烦，要写个分类
        arr2.replaceSubrange(Range.init(uncheckedBounds: (2,3)), with: ["var-replace"])
        
        //分类写法
        arr2.replaceObject(Index: 2, newObject: "var-category")
        print(arr2)
        
        for ele in arr2{
            print(ele)
        }
        
        
        
        //MARK:不可变数组
        let arr4:[String] = ["let-arr"]
        print(arr4)
        
    }

    func dictFunc(){
        //初始化
        var dict:[String:Any] = [:]
        
        //增删改查
        dict["1"] = "一"
        dict["2"] = "二"
        print(dict)
        
        dict.remove(at: dict.index(forKey: "1")!)
        print(dict)
        
        dict["2"] = "2"
        print(dict)
        
        dict.updateValue(["儿"], forKey: "2")
        print(dict)
        
        for key in dict.keys{
            print(dict[key]!)
        }
        
    }

}
/*
 let dateStr:String = "Mon Mar 20 13:41:46 +0800 2017"
 
 
 let formatter = DateFormatter()
 
 // 2.设置时间的格式
 formatter.dateFormat = "EEE MMM d HH:mm:ss Z yyyy"
 
 // 3. 设置时间的区域(真机必须设置，否则可能不会转换成功)
 formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale!
 
 // 4.转换(转换好的时间是去除时区的时间)
 let createdDate = formatter.date(from: dateStr)!
 **/
