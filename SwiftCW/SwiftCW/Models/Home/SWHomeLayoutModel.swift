//
//  SWHomeLayoutModel.swift
//  SwiftCW
//
//  Created by YiXue on 17/3/15.
//  Copyright © 2017年 赵刘磊. All rights reserved.
//

import UIKit
import Foundation
import YYKit



class SWHomeLayoutModel: NSObject {
    var statusModel : SWHomeStatusModel!
    var textLayout : YYTextLayout?
    var nameTextLayout : YYTextLayout?
    var sourceTextLayout:YYTextLayout?
    
    var  textHeight:CGFloat?
    
    
    init(status:SWHomeStatusModel) {
        super.init()
        statusModel = status
        layoutName()
        layoutSource()
        layoutText()
       
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
        let sourceText:NSMutableAttributedString = NSMutableAttributedString();
        let createTime:NSString = WBStatusHelper.string(withTimelineDate: statusModel?.created_at) as NSString
        
        // 时间
        if createTime.length > 0 {
            let timeText:NSMutableAttributedString! = NSMutableAttributedString.init(string: createTime as! String)
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
            
            let hrefResult:NSTextCheckingResult
            let textResult:NSTextCheckingResult
            var href:String! = ""
            var text:String! = ""
            hrefResult = hrefRegex.firstMatch(in: statusModel?.source as! String, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: (statusModel?.source?.length)!))!
            
            textResult = textRegex.firstMatch(in: statusModel?.source as! String, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange.init(location: 0, length: (statusModel?.source?.length)!))!
            
            
            if hrefResult != nil && textResult != nil && hrefResult.range.location != NSNotFound && textResult.range.location != NSNotFound {
                href = (statusModel.source?.substring(with: hrefResult.range))
                text = (statusModel.source?.substring(with: textResult.range))
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
                        
                        
                        
                        //                    let border:YYTextBorder = YYTextBorder()
                        //                    border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
                        //                    border.fillColor = kWBCellTextHighlightBackgroundColor;
                        //                    border.cornerRadius = 3;
                        //                    YYTextHighlight *highlight = [YYTextHighlight new];
                        //                    if (href) highlight.userInfo = @{kWBLinkHrefName : href};
                        //                    [highlight setBackgroundBorder:border];
                        //                    [from setTextHighlight:highlight range:range];
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
        let UrlResults:[NSTextCheckingResult]! = WBStatusHelper.regexUrl().matches(in: text.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: text.rangeOfAll())
        for at in UrlResults{
            if at.range.location == NSNotFound && at.range.length <= 1 {
                continue
            }
            if (text.attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil) {
                text.setColor(kWBCellTextHighlightColor, range: at.range)
                
                // 高亮状态
                let highlight:YYTextHighlight! = YYTextHighlight()
                highlight.setBackgroundBorder(highlightBorder)
                
                let originStr:String = text.string
                let start = originStr.index(originStr.startIndex, offsetBy: at.range.location)
                let end = originStr.index(start, offsetBy: at.range.length)
                let range:Range = Range(uncheckedBounds: (start,end))
                let infoStr = originStr.substring(with: range)
                
                
                highlight.userInfo = [kWBLinkURLName : infoStr]
                
                text.setTextHighlight(highlight, range: at.range)
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
                let start = originStr.index(originStr.startIndex, offsetBy: at.range.location )
                let end = originStr.index(start, offsetBy: at.range.length )
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
    
    override init() {
        super.init()
    }
    
}
