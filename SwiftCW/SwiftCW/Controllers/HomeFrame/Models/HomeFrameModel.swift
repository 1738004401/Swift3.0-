//
//  HomeFrameModel.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/24.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import Foundation
import YYKit

class HomeFrameModel: NSObject {
    

    var statusModel : SWHomeStatusModel!
    
    
    // 顶部留白
    var marginTop : CGFloat = kWBCellTopMargin//顶部灰色留白
    
    // 标题栏
    var titleHeight : CGFloat = 0//标题栏高度，0为没标题栏
    var  titleTextLayout:YYTextLayout?// 标题栏
    
    // 个人资料
    var profileHeight : CGFloat = 0//个人资料高度(包括留白)
    var  nameTextLayout:YYTextLayout? // 名字
    var  sourceTextLayout:YYTextLayout?// 时间/来源
    
    
    // 文本
    var textHeight : CGFloat = 0
    var textLayout:YYTextLayout?
    
    
    // 图片
    var picHeight : CGFloat = 0//图片高度，0为没图片
    var picSize:CGSize = CGSize.init(width: 0, height: 0)
    
    
    
    // 转发
    var retweetHeight : CGFloat=0 //转发高度，0为没转发
    var retweetTextHeight : CGFloat = 0
    var  retweetTextLayout:YYTextLayout?
    
    var retweetPicHeight : CGFloat = 0
    var retweetPicSize:CGSize?
    var retweetCardHeight : CGFloat = 0
    var retweetCardTextLayout:YYTextLayout?
    var retweetCardTextRect : CGRect?
    
    //底部留白
    var marginBottom : CGFloat = kWBCellToolbarBottomMargin
    var height : CGFloat = 0
    
    
    init(status:SWHomeStatusModel) {
        
        super.init()
        statusModel = status
        layout()
        
    }
    private func layout(){
        layoutProfile()
        layoutText()
        layoutPics()
        profileHeight = kWBCellProfileHeight
        height = profileHeight + textHeight + picHeight+20
    
    }
    private func layoutProfile(){
        layoutName()
        layoutSource()
    }
    private func layoutName(){
        let nameText:NSMutableAttributedString  = NSMutableAttributedString.init(string: (statusModel?.user!.name)!)
        
        
        nameText.font = UIFont.systemFont(ofSize: CGFloat(kWBCellNameFontSize))
        nameText.color = kWBCellNameOrangeColor
        nameText.lineBreakMode = NSLineBreakMode.byCharWrapping;
        let container:YYTextContainer = YYTextContainer(size: CGSize.init(width: kWBCellNameWidth, height: 9999.0))
        
        container.maximumNumberOfRows = 1;
        nameTextLayout = YYTextLayout.sw_layout(with: container, text: nameText)
        
        
    }
    
    private func layoutSource(){
        let sourceText:NSMutableAttributedString = NSMutableAttributedString()
        let createTime:NSString = WBStatusHelper.string(withTimelineDate: statusModel?.created_at_local as Date!) as NSString
        
        // 时间
        if createTime.length > 0 {
            let timeText:NSMutableAttributedString! = NSMutableAttributedString.init(string: createTime as String)
            timeText.appendString("  ")
            timeText.font = UIFont.systemFont(ofSize: CGFloat(kWBCellSourceFontSize))
            timeText.color = UIColor.red;
            sourceText.append(timeText)
            
        }
        
        // 来自 XXX
        if (statusModel?.source?.length)! > 0 {
            let hrefRegex:NSRegularExpression!
            let textRegex:NSRegularExpression!
            
            //@"(?<=href=\").+(?=\" )"
            hrefRegex = WBStatusHelper.regexHref()
            textRegex = WBStatusHelper.regexText()
            
            let hrefResult:NSTextCheckingResult?
            let textResult:NSTextCheckingResult?
            var href:String! = ""
            var text:String! = ""
            hrefResult = hrefRegex.firstMatch(in: statusModel?.source as! String, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: (statusModel?.source?.length)!))!
            
            textResult = textRegex.firstMatch(in: statusModel?.source as! String, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: (statusModel?.source?.length)!))!
            
            
            if hrefResult != nil && textResult != nil && hrefResult?.range.location != NSNotFound && textResult?.range.location != NSNotFound {
                href = (statusModel.source?.substring(with: hrefResult!.range))
                text = (statusModel.source?.substring(with: textResult!.range))
            }
            
            
            if (href.lengthOfBytes(using: String.Encoding.utf8) > 0 && text.lengthOfBytes(using: String.Encoding.utf8) > 0) {
                let from:NSMutableAttributedString = NSMutableAttributedString()
                from.appendString("来自 \(text!)")
                from.font = UIFont.systemFont(ofSize: CGFloat(kWBCellSourceFontSize))
                
                from.color = kWBCellTimeNormalColor
                if statusModel.source_allowclick != nil {
                    if statusModel.source_allowclick! > 0 {
                        let range:NSRange = NSRange.init(location: 3, length: text.lengthOfBytes(using: String.Encoding.init(rawValue: 0)))
                        
                        from.setColor(UIColor.orange, range: range)
                    }
                    
                }
                
                sourceText.append(from)
            }
            
            
            
        }
        
        
        let container:YYTextContainer = YYTextContainer(size: CGSize.init(width: kWBCellNameWidth, height: 9999))
        container.maximumNumberOfRows = 1;
        sourceTextLayout = YYTextLayout.sw_layout(with: container, text: sourceText)
        
    }
    
    private func layoutText(){
        //1.0整段文字位置
        let modifier = WBTextLinePositionModifier();
        modifier.font = UIFont.init(name: "Heiti SC", size: CGFloat(kWBCellTextFontSize))
        modifier.paddingTop = 8;
        modifier.paddingBottom = 8;
        
        
        //2.0 文字容器
        let container = YYTextContainer();
        container.size = CGSize.init(width: (kScreen_Width - 2 * CGFloat( kWBCellPadding)), height: CGFloat(HUGE))
        container.linePositionModifier = modifier;
        
        //3.0 关键代码 把普通文本转换成 图片 attachment
        
        let text:NSMutableAttributedString? = textWithStatus(status: statusModel, fontSize: CGFloat(kWBCellTextFontSize), textColor: kWBCellTextNormalColor)
        //4.0 生成 YYTextLayout
        
        let text_layout:YYTextLayout? = YYTextLayout.sw_layout(with: container, text: text!)
        
        
        //5.0设置
        self.textLayout = text_layout;
        
        self.textHeight = modifier.height(forLineCount: (textLayout?.rowCount)!)
        
    }
    private func textWithStatus(status:SWHomeStatusModel?,fontSize:CGFloat,textColor:UIColor) -> NSMutableAttributedString?{
        if (status == nil) {
            return nil
        }
        
        let string:NSMutableString! = status?.text?.mutableCopy() as! NSMutableString;
        if (string?.length == 0){
            return nil
        }
        
        // 字体
        let font:UIFont! = UIFont.systemFont(ofSize: fontSize)
        // 高亮状态的背景
        let highlightBorder:YYTextBorder! = YYTextBorder()
        highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
        highlightBorder.cornerRadius = 3;
        highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
        
        
        let text:NSMutableAttributedString! = NSMutableAttributedString.init(string: status!.text! as String)
        text.font = font;
        text.color = textColor;
        
        
        // 匹配 url
        var urlClipLength = 0;
        
        
        let UrlResults:[NSTextCheckingResult]! = WBStatusHelper.regexUrl().matches(in: text.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: text.rangeOfAll())
        for at in UrlResults{
            
            
            
            
            if at.range.location == NSNotFound && at.range.length <= 1 {
                continue
            }
            var range:NSRange! = at.range;
            range.location -= urlClipLength;
            if (text.attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil) {
//                text.setColor(kWBCellTextHighlightColor, range: at.range)
                
                
                //1.0 将以前的http替换成“网页链接”
                
                let originStr:String = text.string
                let start = originStr.index(originStr.startIndex, offsetBy: range.location )
                let end = originStr.index(start, offsetBy: range.length)
                let emorange:Range = Range(uncheckedBounds: (start,end))
                let infoStr = originStr.substring(with: emorange)
                
                
                
                let emoText:NSAttributedString! = NSAttributedString.init(string: "网页链接", attributes: [NSFontAttributeName:font])
                text.replaceCharacters(in: range, with: emoText)
                urlClipLength = urlClipLength + range.length - 4;

                
                //2.0 设置高亮
                
                let highlight:YYTextHighlight! = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                
                
                let urlRange = NSRange.init(location: range.location, length: 4)
                
                text.setColor(kWBCellTextHighlightColor, range: urlRange)
                highlight.userInfo = [kWBLinkURLName : infoStr]
                text.setTextHighlight(highlight, range: urlRange)
                /*
                 let highlight:YYTextHighlight! = YYTextHighlight()
                 highlight.setBackgroundBorder(highlightBorder)
                 
                 let originStr:String = text.string
                 let start = originStr.index(originStr.startIndex, offsetBy: at.range.location)
                 let end = originStr.index(start, offsetBy: at.range.length)
                 let range:Range = Range(uncheckedBounds: (start,end))
                 
                 
                 let infoStr = originStr.substring(with: range)
                 
                 
                 highlight.userInfo = [kWBLinkURLName : infoStr]
                 
                 text.setTextHighlight(highlight, range: at.range)
                 **/
            }
            
            
            
        }
        
        // 匹配 #用户名#
        let topicResults:[NSTextCheckingResult]! = WBStatusHelper.regexTopic().matches(in: text.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: text.rangeOfAll())
        for at in topicResults{
            if at.range.location == NSNotFound && at.range.length <= 1 {
                continue
            }
            if (text.attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil) {
                text.setColor(kWBCellTextHighlightColor, range: at.range)
                
                // 高亮状态
                let highlight:YYTextHighlight! = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                
                // 数据信息，用于稍后用户点击
                let originStr:String = text.string
                let start = originStr.index(originStr.startIndex, offsetBy: at.range.location+1 )
                let end = originStr.index(start, offsetBy: at.range.length-2 )
                let range:Range = Range(uncheckedBounds: (start,end))
                let infoStr = originStr.substring(with: range)
                
                
                highlight.userInfo = [kWBLinkTopicName : infoStr]
                text.setTextHighlight(highlight, range: at.range)
            }
            
            
            
        }
        
        // 匹配 @用户名
        
        let atResults:[NSTextCheckingResult]! = WBStatusHelper.regexAt().matches(in: text.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: text.rangeOfAll())
        for at in atResults{
            if at.range.location == NSNotFound && at.range.length <= 1 {
                continue
            }
            if (text.attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil) {
                text.setColor(kWBCellTextHighlightColor, range: at.range)
                
                // 高亮状态
                let highlight:YYTextHighlight! = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                
                let originStr:String = text.string
                let start = originStr.index(originStr.startIndex, offsetBy: at.range.location )
                let end = originStr.index(start, offsetBy: at.range.length)
                let range:Range = Range(uncheckedBounds: (start,end))
                let infoStr = originStr.substring(with: range)
                
                
                highlight.userInfo = [kWBLinkAtName : infoStr]
                
                text.setTextHighlight(highlight, range: at.range)
            }
            
            
            
        }
        
        // 匹配 [表情]
        let emoticonResults:[NSTextCheckingResult]! = WBStatusHelper.regexEmoticon().matches(in: text.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: text.rangeOfAll())
        var emoClipLength = 0;
        
        for emo in  emoticonResults {
            if emo.range.location == NSNotFound && emo.range.length <= 1 {
                continue
            }
            var range:NSRange! = emo.range;
            range.location -= emoClipLength;
            if (text.attribute(YYTextHighlightAttributeName, at: UInt(range.location)) != nil) {
                continue
            }
            
            if (text.attribute(YYTextAttachmentAttributeName, at: UInt(range.location)) != nil) {
                continue
            }
            
            let originStr:String = text.string
            let start = originStr.index(originStr.startIndex, offsetBy: range.location )
            let end = originStr.index(start, offsetBy: range.length)
            let emorange:Range = Range(uncheckedBounds: (start,end))
            let infoStr = originStr.substring(with: emorange)
            
            
            let dict:NSDictionary! =  WBStatusHelper.emoticonDic() as NSDictionary
            let imagePath:String? = dict.object(forKey: infoStr) as? String
            let image:UIImage! = WBStatusHelper.image(withPath: imagePath);
            if image == nil{
                continue
            }
            
            let emoText:NSAttributedString! = NSAttributedString.attachmentString(withEmojiImage: image, fontSize: fontSize)
            text.replaceCharacters(in: range, with: emoText)
            emoClipLength = emoClipLength + range.length - 1;
        }
        
        
        return text;
        
    }
    
    private func layoutPics(){
        picSize = CGSize.zero
        picHeight = 0.0
        if statusModel.pic_urls?.count == 0{
            return;
        }
        
        
        var len1_3 :CGFloat = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic
        len1_3 = CGFloatPixelRound(len1_3);
        
        
        switch statusModel.pic_urls!.count {
        case 1:
            picSize = CGSize.init(width: 200, height: 200)
            picHeight = 200;

            break;
        case 2:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = len1_3;
            break;
        case 3:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = len1_3;
            break;
        case 4:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = 2*len1_3 + kWBCellPaddingPic
            break;
        case 5:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = 2*len1_3 + kWBCellPaddingPic
            break;
        case 6:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = 2*len1_3 + kWBCellPaddingPic
            break;
        case 7:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = 3*len1_3 + 2*kWBCellPaddingPic
            break;
        case 8:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = 3*len1_3 + 2*kWBCellPaddingPic
            break;
        case 9:
            picSize = CGSize.init(width: len1_3, height: len1_3)
            picHeight = 3*len1_3 + 2*kWBCellPaddingPic
            break;
        default:
            break;
        }
        
       
    }
    
    override init() {
        super.init()
    }

}
