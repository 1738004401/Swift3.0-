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
    
    
    private var avatarView : UIImageView!
    private var nameLabel : YYLabel!
    private var sourceLabel : YYLabel!
    
    private func setupUI(){
        //上边灰线
        let topGrayLine = UIView()
        topGrayLine.backgroundColor = kWBCellBackgroundColor
        self.addSubview(topGrayLine)
        topGrayLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(10)
            
        }
        
        //头像
        avatarView = UIImageView()
        avatarView.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(avatarView)
        
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(topGrayLine.snp.bottom).offset(8)
            make.left.equalTo(kWBCellPadding)
            make.width.height.equalTo(45)
            make.bottom.equalTo(-8)
        }
        
        let avatarBorder:CALayer = CALayer();
        avatarBorder.frame = avatarView.bounds;
        avatarBorder.borderWidth = CGFloatFromPixel(1);
        avatarBorder.borderColor = UIColor.white.cgColor
        avatarBorder.cornerRadius = 45.0/2.0;
        avatarBorder.shouldRasterize = true;
        avatarBorder.rasterizationScale = YYScreenScale()
        avatarView.layer.addSublayer(avatarBorder)
        
        //发表人
        nameLabel = YYLabel();
//        nameLabel.size = CGSizeMake(kWBCellNameWidth, 24);
//        _nameLabel.left = _avatarView.right + kWBCellNamePaddingLeft;
//        _nameLabel.centerY = 27;
        nameLabel.displaysAsynchronously = true
        nameLabel.ignoreCommonProperties = true
        nameLabel.fadeOnAsynchronouslyDisplay = false
        nameLabel.fadeOnHighlight = false
        nameLabel.lineBreakMode = NSLineBreakMode.byClipping
        nameLabel.textVerticalAlignment = YYTextVerticalAlignment.center
        addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(avatarView.snp.centerY).offset(-7)
            make.left.equalTo(avatarView.snp.right).offset(8)
            make.width.equalTo(kWBCellNameWidth)
            make.height.equalTo(24)
        }
        
        //来源
        sourceLabel = YYLabel()
//        sourceLabel.frame = _nameLabel.frame;
//        sourceLabel.centerY = 47;
        sourceLabel.displaysAsynchronously = true
        sourceLabel.ignoreCommonProperties = true
        sourceLabel.fadeOnAsynchronouslyDisplay = false
        sourceLabel.fadeOnHighlight = false
        addSubview(sourceLabel)
        
        sourceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.equalTo(nameLabel.snp.left)
            make.width.equalTo(kWBCellNameWidth)
            make.height.equalTo(24)
        }


    }
    var statusLayoutModel:SWHomeLayoutModel!
        {
        didSet{
            avatarView.setImageWith(statusLayoutModel.statusModel.user?.avatar_large, placeholder: nil, options: YYWebImageOptions.allowBackgroundTask, manager: WBStatusHelper.avatarImageManager(), progress: nil, transform: nil, completion: nil)
            nameLabel.textLayout = statusLayoutModel.nameTextLayout
            sourceLabel.textLayout = statusLayoutModel.sourceTextLayout
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
