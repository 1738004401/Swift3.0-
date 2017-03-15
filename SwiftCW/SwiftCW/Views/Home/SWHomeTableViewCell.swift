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

class SWHomeTableViewCell: UITableViewCell {

    var labelHeight : Constraint?
    
    var statusLayout : SWHomeLayoutModel?
    {
        didSet{
            let container = YYTextContainer();
            container.size = CGSize.init(width: kScreen_Width, height: CGFloat.greatestFiniteMagnitude);
            
            let str = statusLayout?.statusModel?.text
            let attr = NSAttributedString.init(string: str!)
            let text_layout = YYTextLayout(container: container, text: attr)
            print(text_layout?.rowCount)
            labelHeight?.update(offset: 20*(text_layout?.rowCount)!)
            content_label.textLayout = text_layout
        }
    }
    private lazy var content_label:YYLabel = {
        let label = YYLabel()
        label.textVerticalAlignment = YYTextVerticalAlignment.top;
        label.displaysAsynchronously = true;
        label.fadeOnAsynchronouslyDisplay = false;
        label.fadeOnHighlight = false;
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI(){
        
        contentView.addSubview(content_label)
        content_label.snp.makeConstraints { (make) in
            make.edges.equalTo(0).inset(UIEdgeInsetsMake(10, 10, 10, 10))
            labelHeight =  make.height.equalTo(100).priority(800).constraint
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
