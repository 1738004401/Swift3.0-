//
//  SWLoginController.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/15.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import AFNetworking

class SWLoginController: UIViewController {

    fileprivate lazy var webView:UIWebView = {
    
        let webView = UIWebView()
        return webView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        //2.0 拼接微博请求URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)";
        let url = URL(string: urlStr);
        let request = URLRequest(url: url!);
        webView.loadRequest(request);
    }
    
    override func loadView() {
        view = webView
    }

    
}
extension SWLoginController:UIWebViewDelegate{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlstr = request.url?.absoluteString;
        
        if !urlstr!.hasPrefix(WB_redirect_uri) {
            return true;
        }
        let codeStr = "code=";
        
        if ((request.url?.query?.hasPrefix(codeStr)) != nil) {
            let code = request.url?.query?.substring(from: codeStr.endIndex)
            loadUser(code: code!)
        }
        return false;
    }
    fileprivate func loadUser(code:String){
        
        let params = ["client_id":WB_App_Key, "client_secret":WB_App_Secret, "grant_type":"authorization_code", "code":code, "redirect_uri":WB_redirect_uri];
        
        BaseHTTPMethodTool.shareInstance.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        
        BaseHTTPMethodTool.shareInstance.requestJsonDataWithPath(aPath: "https://api.weibo.com/oauth2/access_token", Params: params as NSDictionary, MethodType: NetworkMethod.Post) { (json, error) in
            if error == nil{
                UserDefaults.standard.set(json, forKey: SWUserJson)
                UserDefaults.standard.synchronize()
                let rootController = RootTabBarController()
                UIApplication.shared.keyWindow?.rootViewController = rootController
            }
        }
        
        
        
    }
}
