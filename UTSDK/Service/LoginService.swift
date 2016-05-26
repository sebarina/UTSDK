//
//  LoginService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/2/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

@objc public protocol LoginServiceDelegate {
    optional func didLoginUser(success: Bool, user: UTUser?, isFresh: Bool, error: String?)
    optional func didGetRegisterCode(success: Bool, error: String?)
    optional func didGetResetCode(success: Bool, error: String?)
    optional func didResetPassword(success: Bool, error: String?)
    
}


public class LoginService: NSObject {
    private weak var delegate: LoginServiceDelegate?
    //private let WeiboRedirectURI : String = "http://www.uteacher.me"
    
    public init(delegate: LoginServiceDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    
    public func loginWithMobile(mobile: String, password: String) {
        let config = UTAPIConfig(apiName: "login", apiNamespace: "member", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["mobile": mobile, "password": password]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let accessToken = response.result?.objectForKey("access_token") as? String ?? ""
                let userId = response.result?.objectForKey("id") as? String ?? ""
                let permissions = response.result?.objectForKey("permissions") as? [String] ?? []
                if accessToken.isEmpty || userId.isEmpty {
                    self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: "Failed to get user info")
                } else {
                    let user = UTUser(userId: userId, accessToken: accessToken, permissions: permissions)
//                    UTRuntime.setCurrentUser(user)
//                    MobClick.profileSignInWithPUID(userId)
                    self.delegate?.didLoginUser?(true, user: user, isFresh: false, error: nil)
                    
                }
                
            } else {
                self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: response.error?.userInfo["error"] as? String)
            }
        })
        
    }
    
    public func loginWithWeibo(redirectURI: String) {
        LFWeiboAuthorizeApi.loginWithWeibo(redirectURI, result: {
            (sso: SSOAuthorizeInfo!, error: NSError!) in
            if error == nil {
                let authData = [
                    "uid": sso.uid,
                    "access_token": sso.accessToken,
                    "expiration_in": sso.expiresIn
                ]
                self.snsLogin("weibo", authData: authData, username: sso.username, avatar: sso.avatar)
            } else {
                self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: error.userInfo["error"] as? String)
            }
        })
    }
    
    func loginWithWechat() {
        LFWechatAuthorizeApi.loginWithWechat(result: {
            (sso: SSOAuthorizeInfo!, error: NSError!) in
            if error == nil {
                let authData = [
                    "openid": sso.openid,
                    "access_token": sso.accessToken,
                    "expires_in": sso.expiresIn
                ]
                self.snsLogin("weixin", authData: authData, username: sso.username, avatar: sso.avatar)
            } else {
                self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: error.userInfo["error"] as? String)
            }
        })
    }
    
    func loginWithTencent() {
        LFTencentAuthorizeApi.getInstance().loginWithTencent(result: {
            (sso: SSOAuthorizeInfo!, error: NSError!) in
            if error == nil {
                let authData = [
                    "openid": sso.openid,
                    "access_token": sso.accessToken,
                    "expires_in": sso.expiresIn
                ]
                self.snsLogin("qq", authData: authData, username: sso.username, avatar: sso.avatar)
            } else {
                self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: error.userInfo["error"] as? String)
            }
        })
    }
    
    func snsLogin(platform: String, authData: [String: AnyObject], username: String, avatar: String) {
        let config = UTAPIConfig(apiName: "snslogin", apiNamespace: "member", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "username": username,
            "avatar": avatar,
            "authdata": [platform: authData]
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let accessToken = response.result?.objectForKey("access_token") as? String ?? ""
                let userId = response.result?.objectForKey("id") as? String ?? ""
                let permissions = response.result?.objectForKey("permissions") as? [String] ?? []
                
                if accessToken.isEmpty || userId.isEmpty {
                    self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: "Failed to get user info")
                } else {
                    let user = UTUser(userId: userId, accessToken: accessToken, permissions: permissions)
                    let isFresh : Bool = response.result?.objectForKey("isFresh") as? Bool ?? false
//                    UTRuntime.setCurrentUser(user)
//                    MobClick.profileSignInWithPUID(userId, provider: platform)
                    self.delegate?.didLoginUser?(true, user: user, isFresh: isFresh, error: nil)
                    
                }
                
            } else {
                self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func getRegisterCode(mobile: String) {
        let config = UTAPIConfig(apiName: "registercode", apiNamespace: "member", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["mobile": mobile]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didGetRegisterCode?(true, error: nil)
            } else {
                self.delegate?.didGetRegisterCode?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func registerWithMobile(mobile: String, username: String, password: String, smsCode: String) {
        let config = UTAPIConfig(apiName: "register", apiNamespace: "member", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "mobile": mobile,
            "username": username,
            "password": password,
            "smscode": smsCode
        ]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let accessToken = response.result?.objectForKey("access_token") as? String ?? ""
                let userId = response.result?.objectForKey("id") as? String ?? ""
                let permissions = response.result?.objectForKey("permissions") as? [String] ?? []
                
                if accessToken.isEmpty || userId.isEmpty {
                    self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: "Failed to get user info")
                } else {
                    let user = UTUser(userId: userId, accessToken: accessToken, permissions: permissions)
                    let isFresh : Bool = response.result?.objectForKey("isFresh") as? Bool ?? false
//                    UTRuntime.setCurrentUser(user)
//                    MobClick.profileSignInWithPUID(userId)
                    self.delegate?.didLoginUser?(true, user: user, isFresh: isFresh, error: nil)
                    
                }
            } else {
                self.delegate?.didLoginUser?(false, user: nil, isFresh: false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func getResetCode(mobile: String) {
        let config = UTAPIConfig(apiName: "resetcode", apiNamespace: "member", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["mobile": mobile]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didGetResetCode?(true, error: nil)
            } else {
                self.delegate?.didGetResetCode?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func resetPassword(newPassword: String, smsCode: String) {
        let config = UTAPIConfig(apiName: "resetpassword", apiNamespace: "member", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "password": newPassword,
            "smscode": smsCode
        ]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didResetPassword?(true, error: nil)
            } else {
                self.delegate?.didResetPassword?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
}