//
//  UIKitStudyController.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/21.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class UIKitStudyController:BaseViewController  {

    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UIKitStudyController")
        return tableView
    }()
    
    lazy var dataSource:[String] = {
        return["UIButton 学习","闭包学习","Foundtion学习"]
    }()
    lazy var subViewControlls:[String] = {
        
        return ["UIButtonStudyController","BiBaoController","ArrayDictStringController"]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNavgation_Status_Height)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-kTabbar_Height)
            
        }
        
        
    }


}
extension UIKitStudyController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIKitStudyController", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let childControllerName = subViewControlls[indexPath.row]
        let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
        let cls = NSClassFromString(nameSpace + "." + childControllerName) as! UIViewController.Type
        
        let controller = cls.init()
        self.navigationController?.pushViewController(controller, animated: true)

    }
}
