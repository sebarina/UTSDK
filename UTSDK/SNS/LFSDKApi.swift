//
//  LFSDKApi.swift
//  ShareKit
//
//  Created by Sebarina Xu on 8/7/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import UIKit

public protocol LFSDKApiDelegate: WXApiDelegate, WeiboSDKDelegate {
    
}


public class LFSDKApi : NSObject, LFSDKApiDelegate{

    private static var instance : LFSDKApi = LFSDKApi()
    
    public class func getInstance() -> LFSDKApi {
        return instance
    }
    
    
    
    /**
    *   @brief  注册App，需要在每次启动第三方应用程序时调用
    *
    *   QQ不需要注册？？？
    */
    public class func registerApp(appid: String, appsecret: String, platform:SSOPlatformType) {
        switch platform {
        case .Wechat:
            if !WXApi.registerApp(appid, withDescription: "InstaPanda") {
                #if DEBUG
                    print("注册Wechat失败")
                #endif
            } else {
                SNSAppInfo.getInstance().appids[SSOPlatformType.Wechat.rawValue] = appid
                SNSAppInfo.getInstance().appsecrets[SSOPlatformType.Wechat.rawValue] = appsecret
            }
            break
        case .Weibo:
            if !WeiboSDK.registerApp(appid) {
                #if DEBUG
                    print("注册微博失败")
                #endif
            } else {
                SNSAppInfo.getInstance().appids[SSOPlatformType.Weibo.rawValue] = appid
                SNSAppInfo.getInstance().appsecrets[SSOPlatformType.Weibo.rawValue] = appsecret
            }
            break
        case .Tencent:
            SNSAppInfo.getInstance().appids[SSOPlatformType.Tencent.rawValue] = appid
            SNSAppInfo.getInstance().appsecrets[SSOPlatformType.Tencent.rawValue] = appsecret
            break
        }
    }
    
    
    /**
    *   @brief  处理SNS客户端程序通过URL启动第三方应用时传递的数据
    *
    *   需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用
    */
    public func handleUrl(url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self) || WeiboSDK.handleOpenURL(url, delegate: self) || TencentOAuth.HandleOpenURL(url)
        
    }
    
    
    
    //////////////////////////// WXApiDelegate //////////////////////////////
    
    /*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
    *
    * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
    * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
    * @param req 具体请求内容，是自动释放的
    */
    public func onReq(req: BaseReq!) {
        
    }
    
    /*! @brief 发送一个sendReq后，收到微信的回应
    *
    * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
    * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
    * @param resp具体的回应内容，是自动释放的
    */
    public func onResp(resp: BaseResp!) {
        let status = resp.errCode
        let msg = resp.errStr
        
        #if DEBUG
            print("微信返回的结果：\(status), \(msg)")
        #endif
        
        let authResp : SendAuthResp? = resp as? SendAuthResp
        if authResp != nil {
            // 登录认证的返回
            if status == 0 {
                let code = authResp!.code
                LFWechatAuthorizeApi.handleWechatResponse(true, forCode: code)
            } else {
                // 认证失败
                LFWechatAuthorizeApi.handleWechatResponse(false, forCode: "")
            }
        }
        
        
    }
    
    ///////////////////////////// WeiboSDKDelegate //////////////////////////////
    /**
    收到一个来自微博客户端程序的请求
    
    收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
    @param request 具体的请求对象
    */
    public func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
    
    /**
    收到一个来自微博客户端程序的响应
    
    收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
    @param response 具体的响应对象
    */
    public func didReceiveWeiboResponse(response: WBBaseResponse!) {
        #if DEBUG
            print("微博返回的结果：\(response.statusCode.rawValue), \(response.isKindOfClass(WBDataTransferObject.self))")
        #endif
        if response.statusCode != WeiboSDKResponseStatusCode.Success {
            // 返回失败
            LFWeiboAuthorizeApi.handleWeiboResponse(false, authData: nil)
            return
        }
        if response.isKindOfClass(WBAuthorizeResponse.self) {
            // SSO 登录结果的回调
            let authorizeResponse = response as! WBAuthorizeResponse
            let userId : String = authorizeResponse.userID
            let accessToken : String = authorizeResponse.accessToken
            let expiresIn : String = "\(authorizeResponse.expirationDate.timeIntervalSinceNow)"
            
            LFWeiboAuthorizeApi.handleWeiboResponse(true, authData: ["uid":userId, "access_token": accessToken, "expiration_in": expiresIn])
        }
    }

}