//
//  LFTencentAuthorizeApi.swift
//  ShareKit
//
//  Created by Sebarina Xu on 8/7/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

class LFTencentAuthorizeApi : NSObject, TencentSessionDelegate{
    private var callback : LFAuthorizeResultBlock?
    private var tencentOAuth : TencentOAuth?
    private static var instance : LFTencentAuthorizeApi = LFTencentAuthorizeApi()
    
    class func getInstance() -> LFTencentAuthorizeApi {
        return instance
    }
    
    func authorizeTencentApi() {
        if SNSAppInfo.getInstance().isPlatformRegistered(type: SSOPlatformType.Tencent) {
            if tencentOAuth == nil {
                tencentOAuth = TencentOAuth(appId: SNSAppInfo.getInstance().appids[SSOPlatformType.Tencent.rawValue]!, andDelegate: self)
            }
        } else {
            #if DEBUG
                print("没有注册QQ应用")
            #endif
        }
    }
    
    func loginWithTencent(result result: LFAuthorizeResultBlock) {
        callback = result
        
        if SNSAppInfo.getInstance().isPlatformRegistered(type: SSOPlatformType.Tencent) {
            if tencentOAuth == nil {
                tencentOAuth = TencentOAuth(appId: SNSAppInfo.getInstance().appids[SSOPlatformType.Tencent.rawValue]!, andDelegate: self)
            }
            tencentOAuth!.authorize([kOPEN_PERMISSION_GET_INFO,kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_SIMPLE_USER_INFO], localAppId: SNSAppInfo.getInstance().appids[SSOPlatformType.Tencent.rawValue]!, inSafari: false)
            
        } else {
            #if DEBUG
                print("没有注册QQ应用")
            #endif
            result(nil,NSError(domain: "qqLogin", code: ResultCode.NOTFOUND.rawValue, userInfo: ["error" : "没有注册QQ应用"]))
        }
    }
    
    func tencentDidLogin() {
        if !tencentOAuth!.getUserInfo() {
            callback?(nil, NSError(domain: "qqLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "QQ认证失败"]))
        }
    }
    
    /**
    * 登录失败后的回调
    * \param cancelled 代表用户是否主动退出登录
    */
    func tencentDidNotLogin(cancelled: Bool) {
        callback?(nil, NSError(domain: "qqLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "QQ认证失败"]))
    }
    
    /**
    * 登录时网络有问题的回调
    */
    func tencentDidNotNetWork() {
        callback?(nil, NSError(domain: "qqLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "网络出错啦!!!"]))
    }
    
    func getUserInfoResponse(response: APIResponse!) {
        let accessToken = tencentOAuth!.accessToken
        let openId : String = tencentOAuth!.openId

        let expiresIn : String = "\(tencentOAuth!.expirationDate.timeIntervalSinceNow)"
        var username : String? = nil
        var avatar : String? = nil
        if response.jsonResponse != nil {
            username = response.jsonResponse["nickname"] as? String
            avatar = response.jsonResponse["figureurl_qq_2"] as? String
        }
        
        if accessToken != nil && !accessToken.isEmpty {
            
            let authData = SSOAuthorizeInfo(uid:"",accessToken:accessToken!, openid: openId, expiresIn: expiresIn, username: username ?? "QQ用户", avatar: avatar ?? "")
            
            callback?(authData,nil)
           
        } else {
            callback?(nil, NSError(domain: "qqLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "QQ认证失败"]))
        }
    }
    
}