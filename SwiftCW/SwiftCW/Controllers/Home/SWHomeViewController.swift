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
import MJRefresh
import SVPullToRefresh
import ODRefreshControl




class SWHomeViewController:BaseViewController  {

    var layouts:[SWHomeLayoutModel] = []
    
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(SWHomeTableViewCell.self, forCellReuseIdentifier: kCellIdentifier_SWHomeTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 75.0
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadData(type: RefreshType.refreshTypeTop)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadData(type: RefreshType.refreshTypeBottom)
        })
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData(type: RefreshType.refreshTypeTop)
    }
    
    private func setupUI() {
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavgation_Status_Height)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kTabbar_Height)
            
        }
        
        
       
    }
    
     func loadData(type:RefreshType){
        
        let params:SWHomeStatuesParams! = SWHomeStatusBiz.getParams(refretype: type, statuses: layouts)
        SWHomeStatusBiz.getLayoutModel(refresh: type, params: params, originLayouts: self.layouts) { (layouts) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.layouts = layouts
            self.tableView.reloadData()
        }

    }
    
}
extension SWHomeViewController:UITableViewDataSource,UITableViewDelegate,SWHomeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.layouts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SWHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier_SWHomeTableViewCell, for: indexPath) as! SWHomeTableViewCell
        cell.statusLayout = layouts[indexPath.row]
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
            var name:NSString! = info?[kWBLinkTopicName] as! NSString
            name = name.byURLEncode() as NSString!
            if (name.length > 0) {
                let url:String?  = "http://m.weibo.cn/k/".appending((name as? String)!)
                let webController =  BaseWebViewController()
                webController.urlString = url
                webController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(webController, animated: true)

                
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

    }
    
}
