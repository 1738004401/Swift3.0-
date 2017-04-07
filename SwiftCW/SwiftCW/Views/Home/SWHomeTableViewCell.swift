//
//  SWHomeTableViewCell.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/14.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import SnapKit
import YYKit


let kCellIdentifier_SWHomeTableViewCell = "SWHomeTableViewCell"

@objc
public protocol SWHomeTableViewCellDelegate{
    @objc optional func cellLinkClicked(containerView:UIView, text:NSAttributedString, range:NSRange, rect:CGRect)
}

class SWHomeTableViewCell: UITableViewCell {

    open var delegate:SWHomeTableViewCellDelegate?
    var labelHeight : Constraint?
    var profileView : SWHomeStatusProfileView!
    var _picViews:NSMutableArray!
    
    var statusLayout : SWHomeLayoutModel?
    {
        didSet{
           
            
            labelHeight?.update(offset: (statusLayout?.textHeight)!)
            content_label.textLayout = statusLayout?.textLayout
            profileView.statusLayoutModel = statusLayout!
            
            
        }
            
    }
    private lazy var content_label:YYLabel = {
        let label = YYLabel()
        label.textVerticalAlignment = YYTextVerticalAlignment.top
        label.displaysAsynchronously = true
        label.fadeOnAsynchronouslyDisplay = false
        label.fadeOnHighlight = false
        label.backgroundColor = UIColor.white
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setupUI()
    }
    
    private func setupUI(){//(^YYTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect)

        //1.0 顶部
        profileView = SWHomeStatusProfileView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
        }
        
        //2.0 status
        let highlightTapAction:YYTextAction?
        highlightTapAction = {
            (containerView:UIView, text:NSAttributedString, range:NSRange, rect:CGRect) in
             self.delegate?.cellLinkClicked!(containerView: containerView, text: text, range: range, rect: rect)
            
        }
        content_label.highlightTapAction = highlightTapAction;
        contentView.addSubview(content_label)
        contentView.backgroundColor = UIColor.white
        content_label.snp.makeConstraints { (make) in
            make.top.equalTo(profileView.snp.bottom)
            make.left.equalTo(kWBCellPadding)
            make.right.equalTo(-kWBCellPadding)
            make.bottom.equalTo(0)
            labelHeight =  make.height.equalTo(100).priority(800).constraint
            
        }
        //3.0图片
        
//        let picViews:NSMutableArray = NSMutableArray()
//        
//        for  _ in 0..<9 {
//            let imageView = YYControl()
//            imageView.size = CGSize.init(width: 100.0, height: 100.0)
//            imageView.isHidden = true
//            imageView.clipsToBounds = true
//            imageView.backgroundColor = kWBCellHighlightColor;
//            imageView.isExclusiveTouch = true;
//            
//        }
//        _picViews = picViews

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
