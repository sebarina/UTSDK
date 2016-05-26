//
//  BaseActivity.swift
//  InstaPanda
//
//  Created by Sebarina Xu on 7/31/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import UIKit

public protocol ActivityDelegate : class {
    func didReturnResult(forActivity forActivity:UIActivity, success: Bool, error: String?)
}

/// 分享Activity的基类，主要管理分享数据的处理
public class BaseActivity: UIActivity {
    
    /// 待分享的数据
    public var shareData : ShareData?
    
    /// 分享完成后的回调delegate
    weak var delegate : ActivityDelegate?
    
    init(delegate:ActivityDelegate) {
        self.delegate = delegate
        super.init()
        
    }
    
    override public class func activityCategory() -> UIActivityCategory {
        return UIActivityCategory.Share
    }
    
    override public func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        return true
    }
    
    /**
    执行share之前的数据准备
    
    - parameter activityItems: 传给share activity的数据
    */
    override public func prepareWithActivityItems(activityItems: [AnyObject]) {
        shareData = activityItems[0] as? ShareData
        
    }
}
