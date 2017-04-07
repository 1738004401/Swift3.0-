//
//  RootTabBarController.swift
//  Swift实战
//
//  Created by YiXue on 17/3/14.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    var tabbar_normal_imgs = ["tabbar_home","tabbar_message_center"]
    var tabbar_selected_imgs = ["tabbar_home_highlighted","tabbar_message_center_highlighted"]
    var tabbar_titles = ["首页","UIKit"]
    var tabbar_controllernames = ["HomeFrameVC","UIKitStudyController"]
    private lazy var custom_controllers:[UIViewController] = {
        return [UIViewController]()
    }()
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        addChildViewControllers();
        viewControllers = custom_controllers
    }

    private func addChildViewControllers(){
        
        for i in 0..<tabbar_controllernames.count{
            addChildViewController(childControllerName: tabbar_controllernames[i], title: tabbar_titles[i], tabbarNormalImage: tabbar_normal_imgs[i],tabbarSelectedImage:tabbar_selected_imgs[i])
        }
    }
    private func addChildViewController(childControllerName: String, title: String, tabbarNormalImage: String ,tabbarSelectedImage:String) {
        let nameSpace = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
        let cls = NSClassFromString(nameSpace + "." + childControllerName) as! UIViewController.Type
        
        let controller = cls.init()
        controller.tabBarItem.image = UIImage(named: tabbarNormalImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: tabbarSelectedImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        controller.tabBarItem.title = title;
        
        var selectedTextAttrs = [String:AnyObject]()
        selectedTextAttrs[NSForegroundColorAttributeName] = UIColor.orange;
        controller.tabBarItem.setTitleTextAttributes(selectedTextAttrs, for: UIControlState.selected)
        
        let navgationController = BaseNavigationController.init(rootViewController: controller)
        custom_controllers.append(navgationController)
        
        
        
        
        
    }
    
}
