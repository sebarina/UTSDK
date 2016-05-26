//
//  LFWeiboAuthorizeApi.swift
//  ShareKit
//
//  Created by Sebarina Xu on 8/7/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation


class LFWeiboAuthorizeApi {
    private static var callback : LFAuthorizeResultBlock?
    
//    private static var instance : LFWeiboAuthorizeApi = LFWeiboAuthorizeApi()
//    
//    class func getInstance() -> LFWeiboAuthorizeApi {
//        return instance
//    }
    
    class func loginWithWeibo(redirectUri: String, result: LFAuthorizeResultBlock) {
        callback = result
        if SNSAppInfo.getInstance().isPlatformRegistered(type: SSOPlatformType.Weibo) {
            let request : WBAuthorizeRequest = WBAuthorizeRequest()
            request.redirectURI = redirectUri
            request.scope = "all"
            if !WeiboSDK.sendRequest(request) {
                #if DEBUG
                    print("发送失败")
                #endif
                result(nil,NSError(domain: "WeiboLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "微博认证请求发送失败"]))
            }
        } else {
            #if DEBUG
                print("没有注册微博应用")
            #endif
            result(nil,NSError(domain: "WeiboLogin", code: ResultCode.NOTFOUND.rawValue, userInfo: ["error" : "没有注册微博应用"]))
        }
    
    }
    
    class func handleWeiboResponse(result: Bool, authData:[NSObject:AnyObject]?){
        if result {
            let uid : String = authData!["uid"] as! String
            let accessToken : String = authData!["access_token"] as! String
            let expiresIn : String = authData!["expiration_in"] as! String
            
            WBHttpRequest(forUserProfile: uid, withAccessToken: accessToken, andOtherProperties: nil, queue: nil, withCompletionHandler: {
                (s1:WBHttpRequest!, s2: AnyObject!, s3: NSError!) in
                var username : String = "微博用户" //// 如果获取用户信息出错了，此处使用默认用户名“微博用户”登录App
                var avatar : String = ""
                if s3 == nil {
                    
                    username = (s2 as? WeiboUser)?.name ?? "微博用户"
                    avatar = (s2 as? WeiboUser)?.avatarHDUrl ?? ""
                }
                let authInfo : SSOAuthorizeInfo = SSOAuthorizeInfo(uid: uid,accessToken: accessToken, openid: "", expiresIn: expiresIn, username: username, avatar: avatar)
                
                self.callback?(authInfo,nil)
                
            })
            
            
        } else {
            callback?(nil,NSError(domain: "WeiboLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "微博认证失败"]))
        }
    }
}