//
//  LFAuthorizeApi.swift
//  ShareKit
//
//  Created by Sebarina Xu on 8/7/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

class LFWechatAuthorizeApi {
    
    static private var callback : LFAuthorizeResultBlock?
    
    class func loginWithWechat(result result: LFAuthorizeResultBlock) {
        callback = result
        if !WXApi.isWXAppInstalled() {
            #if DEBUG
                print("没有安装微信")
                
            #endif
            result(nil,NSError(domain: "WechatLogin", code: ResultCode.NOTFOUND.rawValue, userInfo: ["error" : "没有安装微信"]))
        }
        
        if SNSAppInfo.getInstance().isPlatformRegistered(type: SSOPlatformType.Wechat) {
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo,snsapi_base"
            req.state = "123"
            if !WXApi.sendReq(req) {
                print("微信认证请求发送失败")
                result(nil,NSError(domain: "WechatLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "微信认证请求发送失败"]))
            }
        } else {
            #if DEBUG
                print("没有注册微信应用")
            #endif
            result(nil,NSError(domain: "WechatLogin", code: ResultCode.NOTFOUND.rawValue, userInfo: ["error" : "没有注册微信应用"]))
        }
        
        
        
    
    }
    
    class func handleWechatResponse(result: Bool, forCode:String) {
        if !result {
            callback?(nil, NSError(domain: "WechatLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "微信认证失败"]))
            return
        }
        
        let appid : String = SNSAppInfo.getInstance().appids[SSOPlatformType.Wechat.rawValue]!
        let appsecret : String = SNSAppInfo.getInstance().appsecrets[SSOPlatformType.Wechat.rawValue]!
        let requestParams = ["appid": appid, "secret": appsecret,"code": forCode, "grant_type": "authorization_code"]
        
        UTAPIRequest.startRawAPIRequest("https://api.weixin.qq.com/sns/oauth2/access_token", method: .GET, params: requestParams, headers: nil, callback: {
            (s1: UTAPIResponse) in
            if s1.success {
                let s2 : AnyObject = s1.result!
                let access_token = s2.objectForKey("access_token") as? String
                let openid = s2.objectForKey("openid") as? String
                let expiresIn = s2.objectForKey("expires_in") as? String
                
                if access_token != nil && openid != nil {
                    // get user info
                    self.getUserInfo(forAccesstoken: access_token!, openId: openid!, expiresIn: expiresIn ?? "7200")
                } else {
                    self.callback?(nil, NSError(domain: "WechatLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "微信认证失败"]))
                }
            } else {
                self.callback?(nil, NSError(domain: "WechatLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "微信认证失败"]))
            }
        })
        
    }
    
    
    class func getUserInfo(forAccesstoken forAccesstoken:String,openId:String,expiresIn:String) {
        let request : UTAPIRequest = UTAPIRequest(url: "api.weixin.qq.com/sns/userinfo")
        request.requestParams = ["access_token":forAccesstoken, "openid":openId]
        request.needDecodeResponse = false
        request.startRequestWithMethod(.GET, callback:{
            (s1: UTAPIResponse) in
            if s1.success {
                let s2 : AnyObject = s1.result!
                let username = s2.objectForKey("nickname") as? String
                let avatar = s2.objectForKey("headimgurl") as? String
                let authInfo : SSOAuthorizeInfo = SSOAuthorizeInfo(uid:"",accessToken:forAccesstoken, openid: openId, expiresIn: expiresIn, username: username ?? "微信用户", avatar: avatar ?? "")
                self.callback?(authInfo,nil)
                
               
            } else {
                self.callback?(nil, NSError(domain: "WechatLogin", code: ResultCode.SERVREERROR.rawValue, userInfo: ["error" : "微信认证失败"]))
            }
            
        })
    }
}