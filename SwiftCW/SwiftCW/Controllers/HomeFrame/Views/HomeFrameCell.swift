//
//  HomeFrameCell.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/24.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import YYKit


let kCellIdentifier_HomeFrameCell = "HomeFrameCell"

@objc
public protocol HomeFrameCellDelegate{
    @objc optional func cellLinkClicked(containerView:UIView, text:NSAttributedString, range:NSRange, rect:CGRect)
}

class HomeFrameCell: UITableViewCell {

    open var delegate:HomeFrameCellDelegate?
    var profileView : HomeProfileView!
    var picViews:[YYControl]!
    var homeFrameLayout : HomeFrameModel!
        {
        didSet{
            //1.0用户情况
            profileView.homeFrameLayout = homeFrameLayout
            
            //2.0 富文本

            content_label.textLayout = homeFrameLayout?.textLayout
            content_label.frame = CGRect.init(x: kWBCellPadding, y: homeFrameLayout.profileHeight+20, width: kScreen_Width-2*kWBCellPadding, height: homeFrameLayout.textHeight)
            //3.0 图片组
            setUpPics(model: homeFrameLayout)
        }
        
    }
    private func setUpPics(model:HomeFrameModel){
        let picSize = model.picSize;
        let picsCount = model.statusModel.pic_urls?.count ?? 0;
        
        
        
        let imageTop =  model.profileHeight + model.textHeight + 20
        for  i in 0..<9 {
            let imageView = self.picViews[i];
            if (i >= picsCount) {
                imageView.layer.cancelCurrentImageRequest()
                imageView.isHidden = true;
            } else {
                var origin:CGPoint = CGPoint.init(x: 0, y: 0)
                switch picsCount {
                case 1:
                    origin.x = kWBCellPadding
                    origin.y = imageTop
                    break
                case 4:
                     origin.x = kWBCellPadding + CGFloat((i % 2)) * (picSize.width + kWBCellPaddingPic)
                     origin.y = imageTop + CGFloat((i / 2)) * (picSize.height + kWBCellPaddingPic)
                    break
                
                default:
                    origin.x = kWBCellPadding + CGFloat((i % 3)) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + CGFloat((i / 3)) * (picSize.height + kWBCellPaddingPic)
                    break
                }
                
                
               imageView.frame = CGRect.init(origin: origin, size: picSize)
               imageView.isHidden = false;
                let pic:NSDictionary? = model.statusModel.pic_urls?[i] as? NSDictionary
                
                
                imageView.layer.setImageWith(URL.init(string: pic?.object(forKey: "thumbnail_pic") as! String), placeholder: nil)
//                imageView.layer.setImageWith(URL.init(string: pic?.object(forKey: "thumbnail_pic") as! String), placeholder: nil, options: YYWebImageOptions.avoidSetImage, completion: { (image, url, from, stage, error) in
//                    
//                    
//                    
//                    
//                    
//                })
//                [imageView.layer setImageWithURL:pic.bmiddle.url
//                    placeholder:nil
//                    options:YYWebImageOptionAvoidSetImage
//                    completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
//                    @strongify(imageView);
//                    if (!imageView) return;
//                    if (image && stage == YYWebImageStageFinished) {
//                    int width = pic.bmiddle.width;
//                    int height = pic.bmiddle.height;
//                    CGFloat scale = (height / width) / (imageView.height / imageView.width);
//                    if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
//                    imageView.contentMode = UIViewContentModeScaleAspectFill;
//                    imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
//                    } else { // 高图只保留顶部
//                    imageView.contentMode = UIViewContentModeScaleToFill;
//                    imageView.layer.contentsRect = CGRectMake(0, 0, 1, (float)width / height);
//                    }
//                    ((YYControl *)imageView).image = image;
//                    if (from != YYWebImageFromMemoryCacheFast) {
//                    CATransition *transition = [CATransition animation];
//                    transition.duration = 0.15;
//                    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//                    transition.type = kCATransitionFade;
//                    [imageView.layer addAnimation:transition forKey:@"contents"];
//                    }
//                    }
//                    }];

                
                
               
            }
        }

        
        
        
        
    
    }
    private lazy var content_label:YYLabel = {
        let label = YYLabel()
        label.textVerticalAlignment = YYTextVerticalAlignment.top
        label.displaysAsynchronously = true
        label.fadeOnAsynchronouslyDisplay = false
        label.fadeOnHighlight = false
        label.backgroundColor = UIColor.white
        let highlightTapAction:YYTextAction?
        highlightTapAction = {
            (containerView:UIView, text:NSAttributedString, range:NSRange, rect:CGRect) in
            self.delegate?.cellLinkClicked!(containerView: containerView, text: text, range: range, rect: rect)
            
        }
        label.highlightTapAction = highlightTapAction;
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
        setupUI()
    }
    
    private func setupUI(){//(^YYTextAction)(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect)
        
        //1.0 顶部
        profileView = HomeProfileView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(profileView)
        
        //2.0 status

        contentView.addSubview(content_label)
        contentView.backgroundColor = UIColor.white
        
        //3.0 图片
        
        var picViews:[YYControl] = [];
        for _ in 0..<9 {
            let imageView:YYControl = YYControl();
            imageView.size = CGSize.init(width: 100, height: 100)
            imageView.isHidden = true;
            imageView.clipsToBounds = true;
            imageView.backgroundColor = kWBCellHighlightColor;
            imageView.isExclusiveTouch = true;
            picViews.append(imageView)
            contentView.addSubview(imageView)
        
        }
        self.picViews = picViews;
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
