//
//  Nothing.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/15.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class Nothing: NSObject {
    /*
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
     
     
     
     
     class SWHomeViewController:BaseViewController  {
     
     let tableView:UITableView = {
     let tableView = UITableView()
     //        tableView.register(SWHomeTableViewCell.self, forCellReuseIdentifier: kCellIdentifier_SWHomeTableViewCell)
     
     return tableView
     }()
     
     lazy var layouts:[WBStatusLayout] = {
     return [WBStatusLayout]()
     }()
     
     override func viewDidLoad() {
     super.viewDidLoad()
     setupUI()
     loadHttp(type: RefreshType.refreshTypeTop)
     }
     private func setupUI() {
     
     tableView.dataSource = self
     tableView.delegate = self
     tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
     let dict = json as? NSDictionary;
     
     let item:WBTimelineItem = WBTimelineItem.model(withJSON: json)!
     
     for status in (item.statuses)!{
     let layout:WBStatusLayout = WBStatusLayout.init(status: status, style: WBLayoutStyle.timeline)
     self.layouts.append(layout)
     }
     self.tableView.reloadData()
     
     
     }) { (_, error) in
     print(error)
     }
     
     }
     
     
     }
     extension SWHomeViewController:UITableViewDataSource,UITableViewDelegate{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return layouts.count;
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier_SWHomeTableViewCell, for: indexPath)
     
     let cellID = "cell"
     var cell:WBStatusCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as! WBStatusCell?
     if (cell == nil) {
     cell = WBStatusCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
     }
     
     cell?.setLayout(layouts[indexPath.row] )
     return cell!
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return layouts[indexPath.row].height
     }
     
     }

     **/
}
