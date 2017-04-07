//
//  HomeProfileView.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/24.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import YYKit
class HomeProfileView: UIView {

    private var avatarView : UIImageView!
    private var nameLabel : YYLabel!
    private var sourceLabel : YYLabel!
    
    private func setupUI(){
        //上边灰线
        let topGrayLine = UIView()
        topGrayLine.backgroundColor = kWBCellBackgroundColor
        self.addSubview(topGrayLine)
        //头像
        avatarView = UIImageView()
        avatarView.size =  CGSize.init(width: 40, height: 40)
        avatarView.origin = CGPoint.init(x: kWBCellPadding, y: kWBCellPadding + 3.0)
        avatarView.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(avatarView)
        
        
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
        nameLabel.size = CGSize.init(width: kWBCellNameWidth, height: 24.0)
        nameLabel.left = avatarView.right + kWBCellNamePaddingLeft;
        nameLabel.centerY = 27;

        nameLabel.displaysAsynchronously = true
        nameLabel.ignoreCommonProperties = true
        nameLabel.fadeOnAsynchronouslyDisplay = false
        nameLabel.fadeOnHighlight = false
        nameLabel.lineBreakMode = NSLineBreakMode.byClipping
        nameLabel.textVerticalAlignment = YYTextVerticalAlignment.center
        addSubview(nameLabel)
        
        
        //来源
        sourceLabel = YYLabel()
        sourceLabel.frame = nameLabel.frame;
        sourceLabel.centerY = 47;
        sourceLabel.displaysAsynchronously = true
        sourceLabel.ignoreCommonProperties = true
        sourceLabel.fadeOnAsynchronouslyDisplay = false
        sourceLabel.fadeOnHighlight = false
        addSubview(sourceLabel)
        
        
    }
    var homeFrameLayout:HomeFrameModel!
        {
        didSet{
            //1.0 头像frame
            avatarView.setImageWith(homeFrameLayout.statusModel.user?.avatar_large, placeholder: nil, options: YYWebImageOptions.allowBackgroundTask, manager: WBStatusHelper.avatarImageManager(), progress: nil, transform: nil, completion: nil)
            //2.0 名称 frame
            nameLabel.textLayout = homeFrameLayout.nameTextLayout
            //3.0 来源 frame
            sourceLabel.textLayout = homeFrameLayout.sourceTextLayout
            
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
