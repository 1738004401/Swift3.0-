//
//  SWHomeStatusProfileView.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/16.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import SnapKit
import YYKit

class SWHomeStatusProfileView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    private var avatarView:UIImageView!
    var statusModel:SWHomeStatusModel?
    {
        didSet{
            avatarView.setImageWith(statusModel?.user?.avatar_large, placeholder: nil, options: YYWebImageOptions.allowBackgroundTask, manager: WBStatusHelper.avatarImageManager(), progress: nil, transform: nil, completion: nil)
            
        }
    }
    private func setupUI(){
        //上边灰线
        let topGrayLine = UIView()
        topGrayLine.backgroundColor = kWBCellBackgroundColor
        self.addSubview(topGrayLine)
        topGrayLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(8)
            
        }
        
        //头像
        avatarView = UIImageView()
        avatarView.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(avatarView)
        
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(topGrayLine.snp.bottom).offset(8)
            make.left.equalTo(kWBCellPadding)
            make.width.height.equalTo(40)
            make.bottom.equalTo(-8)
        }
        
        let avatarBorder:CALayer = CALayer();
        avatarBorder.frame = avatarView.bounds;
        avatarBorder.borderWidth = CGFloatFromPixel(1);
        avatarBorder.borderColor = UIColor.white.cgColor
        avatarBorder.cornerRadius = 40.0/2.0;
        avatarBorder.shouldRasterize = true;
        avatarBorder.rasterizationScale = YYScreenScale();
        avatarView.layer.addSublayer(avatarBorder)
        

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
