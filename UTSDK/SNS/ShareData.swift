//
//  ShareData.swift
//  ShareKit
//
//  Created by Sebarina Xu on 8/6/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import UIKit

public enum ShareContentType {
    /*
    *   @brief  分享图片
    **/
    case Image
    /*
    *   @brief  分享视频
    **/
    case Video
    /*
    *   @brief  分享网页
    **/
    case WebPage
}

/**
*   @brief  sharedata的设置过程：
*   1. 初始化sharedata，title, description, type
*   2. 设置分享的图片（如果没有则不执行这一步）
*/
public class ShareData : UIActivityItemProvider {
    /*
    *   @brief  分享标题
    **/
    public var title : String
    
    /*
    *   @brief  分享内容描述
    **/
    public var desc : String
    
    /*
    *   @brief  分享内容的缩略图, 有个默认图标
    **/
    public var thumbnail : UIImage = UIImage(named: "ico_appicon")!
    
    /*
    *   @brief  分享的图片
    **/
    public var shareImage : UIImage = UIImage(named: "ico_appicon")!
    
    /*
    *   @brief  分享视频的url
    **/
    public var videoUrl : String?
    
    /*
    *   @brief  分享网页的url
    **/
    public var webPageUrl : String?
    
    /*
    *   @brief  分享内容的类型（图片、视频、网页）
    **/
    public var contentType : ShareContentType
    
    public init(title: String, description: String, type: ShareContentType) {
        self.title = title
        self.desc = description
        self.contentType = type
        super.init(placeholderItem: "Placeholder")
    }
    
    /*
    *   @brief  设置分享内容的图片，同时根据改图片生成分享所需的缩略图
    **/
    public func setImage(image : UIImage) {
        shareImage = image
        let width : CGFloat = 100
        let height = width*image.size.height/image.size.width
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        image.drawInRect(CGRectMake(0, 0, width, height))
        thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // called to fetch data after an activity is selected. you can return nil.
    override public func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        return self
    }
}