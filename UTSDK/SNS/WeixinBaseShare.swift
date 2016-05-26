//
//  WeixinBaseShare.swift
//  InstaPanda
//
//  Created by Sebarina Xu on 8/1/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import UIKit

public enum WeixinShareType {
    /*
    *   @brief  分享到微信好友
    **/
    case SessionShare
    /*
    *   @brief  分享到微信朋友圈
    **/
    case MomentsShare
    /*
    *   @brief  微信收藏
    **/
    case FavoriteShare
}

public class WeixinBaseShare: BaseActivity {
    
    /*
    *   @brief  微信分享的场景: 朋友圈，好友，收藏
    **/
    public var shareType : WeixinShareType = .SessionShare
    
    override public func performActivity() {
        if !WXApi.isWXAppInstalled() {
            activityDidFinish(true)
            delegate?.didReturnResult(forActivity: self, success: false, error: "没有安装微信App")
            self.activityDidFinish(true)
            return
        }
        
        if shareData != nil {            
            if !LFShareApi.weixinShare(shareData!, shareType: shareType){
                delegate?.didReturnResult(forActivity: self, success: false, error: "分享失败")
            } else {
                delegate?.didReturnResult(forActivity: self, success: true, error: nil)
            }
        }
        
        self.activityDidFinish(true)
    }
}
