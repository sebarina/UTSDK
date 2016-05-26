//
//  SNSAppInfo.swift
//  ShareKit
//
//  Created by Sebarina Xu on 8/7/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

struct AppCallBack {
    var isBack : Bool = false
    var backData : AnyObject?
}

class SNSAppInfo {
    /**
    *   @brief  ["wechat":"xxx", "weibo":"xxx", "tencent":"xxx"]
    */
    var appids: [String: String] = [String: String]()
    var appsecrets : [String: String] = [String: String]()
    
    var appcallback : [String: AppCallBack] = [String: AppCallBack]()
    
    private static var instance : SNSAppInfo = SNSAppInfo()
    
    class func getInstance() -> SNSAppInfo {
        return instance
    }
    
    /**
    判断第三方平台是否注册
    
    - parameter type: 第三方平台的类型， 微信，微博，or QQ
    
    - returns: true or false
    */
    func isPlatformRegistered(type type: SSOPlatformType) -> Bool {
        return appids[type.rawValue] != nil && appsecrets[type.rawValue] != nil
    }
}