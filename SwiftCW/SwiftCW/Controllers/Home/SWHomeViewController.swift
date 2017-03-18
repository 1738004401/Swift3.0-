//
//  SWHomeViewController.swift
//  Swift实战
//
//  Created by YiXue on 17/3/14.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import SnapKit
import AFNetworking
import MJExtension
import YYKit




class SWHomeViewController:BaseViewController  {

    let tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(SWHomeTableViewCell.self, forCellReuseIdentifier: kCellIdentifier_SWHomeTableViewCell)
        
        return tableView
    }()
    
    var layouts:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHttp(type: RefreshType.refreshTypeTop)
    }
    private func setupUI() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 75.0
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
//        tableView.backgroundView?.backgroundColor = UIColor.clear;
//        self.view.backgroundColor = kWBCellBackgroundColor;
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavgation_Status_Height)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kTabbar_Height)
            
        }

    }
    private func loadHttp(type:RefreshType){
        switch type {
        case .refreshTypeTop:
            break
            
        case .refreshTypeBottom:
            break
            
       
        }
        
        //2.0 拼接参数
        
        let url = URL(string: "https://api.weibo.com/")
        let manager = AFHTTPSessionManager.init(baseURL: url)
        
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as? Set<String>
        
        var params = ["access_token":SWUser.curUser()?.access_token] ;
        params["since_id"] = "\(0)";
        
        let path = "2/statuses/home_timeline.json";
       
        manager.get(path, parameters: params, progress: { (_) in
            
        }, success: { (task:URLSessionDataTask, json) in
            let dict : [String:AnyObject] = json as! [String : AnyObject]
            let temps : [AnyObject] = dict["statuses"] as! [AnyObject]
            
            let statues:NSMutableArray = SWHomeStatusModel.mj_objectArray(withKeyValuesArray: temps)
            
            for statue in statues{
                let layout = SWHomeLayoutModel.init(status: statue as! SWHomeStatusModel)
                self.layouts.add(layout)
            }
            
            self.tableView.reloadData()
            
            
        }) { (_, error) in
            print(error)
        }

    }

    
}
extension SWHomeViewController:UITableViewDataSource,UITableViewDelegate,SWHomeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.layouts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SWHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier_SWHomeTableViewCell, for: indexPath) as! SWHomeTableViewCell
        cell.statusLayout = layouts[indexPath.row] as? SWHomeLayoutModel
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func cellLinkClicked(containerView: UIView, text: NSAttributedString, range: NSRange, rect: CGRect) {
        let highlight:YYTextHighlight? = text.attribute(YYTextHighlightAttributeName, at: UInt(range.location)) as? YYTextHighlight
        let info = highlight?.userInfo;
        
        if (info?.count == 0) {
            return
        }
        
        if ((info?[kWBLinkTopicName]) != nil) {
            let name:NSString! = info?[kWBLinkTopicName] as! NSString
            if (name.length > 0) {//NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name;
                let url:String?  = "http://m.weibo.cn/n/".appending((name as? String)!)
            }
            return;
        }
        if ((info?[kWBLinkURLName]) != nil) {
            let name:String! = info?[kWBLinkURLName] as! String!
            let webController =  BaseWebViewController()
            webController.urlString = name
            webController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webController, animated: true)
            
            return;
        }

        
//        if (info[kWBLinkAtName]) {
//            NSString *name = info[kWBLinkAtName];
//            name = [name stringByURLEncode];
//            if (name.length) {
//                NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
//                YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//            return;
//        }


    }
    
}
