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




class SWHomeViewController:BaseViewController  {

    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(SWHomeTableViewCell.self, forCellReuseIdentifier: kCellIdentifier_SWHomeTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 75.0
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.clear
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadHttp(type: RefreshType.refreshTypeTop)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.loadHttp(type: RefreshType.refreshTypeBottom)
        })

        
        return tableView
    }()
    
    var layouts:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHttp(type: RefreshType.refreshTypeTop)
    }
    
    private func setupUI() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavgation_Status_Height)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kTabbar_Height)
            
        }

    }
    
    private func loadHttp(type:RefreshType){
        
        var params:SWHomeStatuesParams!
        
        switch type {
        case .refreshTypeTop:
            params = SWHomeStatusBiz.getParams(refretype: RefreshType.refreshTypeTop, statuses: layouts as? [SWHomeLayoutModel])
            break
            
        case .refreshTypeBottom:
            params = SWHomeStatusBiz.getParams(refretype: RefreshType.refreshTypeBottom, statuses: layouts as? [SWHomeLayoutModel])
            break
            
        }
        //2.0 拼接参数
        SWHomeStatusBiz.getStatusesFromSqlite(params: params) { (array) in
            if array == nil {//网络请求
                
                SWHttpManager.requestWeiboTimeline(apath: "https://api.weibo.com/2/statuses/home_timeline.json", params: params, block: { (json, error) in
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.mj_footer.endRefreshing()
                    if error == nil {
                        
                        let statues = SWHomeStatusBiz.getStatuses(json: json)
                        self.layouts = SWHomeStatusBiz.getStatusLayout(refresh:type, originLayouts: self.layouts as! [SWHomeLayoutModel], beAddStatusModeles: statues as! [SWHomeStatusModel]) as! NSMutableArray
                        
                        self.tableView.reloadData()
                    }

                })
                
                
            }else{//数据库
                
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                
               self.layouts =  SWHomeStatusBiz.getStatusLayout(refresh:type, originLayouts: self.layouts as! [SWHomeLayoutModel], beAddStatusModeles: array!) as! NSMutableArray
                
                self.tableView.reloadData()

                
            }
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

    }
    
}
