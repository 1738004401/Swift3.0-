//
//  BaseWebViewController.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/16.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import SnapKit
import WebKit


class BaseWebViewController: BaseViewController {
    open var urlString:String?
    private var webView:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        view.addSubview(webView!)
        webView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsetsMake(CGFloat(kNavgation_Status_Height), 0, 0, 0))
        })
        let request:URLRequest = URLRequest(url: URL.init(string: urlString!)!)
        webView?.navigationDelegate = self;
        webView?.uiDelegate = self;
        webView?.load(request)

    }

    
}
extension BaseWebViewController:WKNavigationDelegate,WKUIDelegate{
    
}
