//
//  SSOAuthorizeInfo.swift
//  ShareKit
//
//  Created by Sebarina Xu on 8/7/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public typealias LFAuthorizeResultBlock = (SSOAuthorizeInfo!, NSError!) -> Void

public enum ResultCode : Int {
    case OK = 200
    case SERVREERROR = 500
    case NOTFOUND = 404
    case CANCELED = 300
}

public enum SSOPlatformType : String {
    case Wechat = "wechat"
    case Weibo = "weibo"
    case Tencent = "tencent"
}

public struct SSOAuthorizeInfo {
    var uid : String  // user id
    var accessToken : String
    var openid : String
    var expiresIn : String
    var username : String
    var avatar : String
}