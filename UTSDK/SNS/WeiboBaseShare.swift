//
//  WeiboShare.swift
//  InstaPanda
//
//  Created by Sebarina Xu on 7/31/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import UIKit

class WeiboBaseShare: BaseActivity {
   
    // 微博share的动作执行，主要是利用准备好的数据调用微博的API
    override func performActivity() {
        if shareData != nil {
            if LFShareApi.weiboShare(shareData!) {
                delegate?.didReturnResult(forActivity: self, success: true, error: nil)
            } else {
                delegate?.didReturnResult(forActivity: self, success: false, error: "分享失败")
            }
            
        }
        
        activityDidFinish(true)
    }
    
}
