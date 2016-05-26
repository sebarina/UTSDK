//
//  UTAPIConfig.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/2/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public struct UTAPIConfig {
    /// API名， 如 login，snslogin
    public var apiName: String
    /// API功能域名， 如 Member － 登录注册相关，Trainning － 训练相关
    public var apiNamespace: String
    /// API版本号
    public var apiVersion: String
    /// 访问该API是否需要用户access token
    public var apiIsNeedAuth: Bool
    
    public init(apiName: String, apiNamespace: String, apiVersion: String, apiIsNeedAuth: Bool) {
        self.apiName = apiName
        self.apiNamespace = apiNamespace
        self.apiVersion = apiVersion
        self.apiIsNeedAuth = apiIsNeedAuth

    }
    
}