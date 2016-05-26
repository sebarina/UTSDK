//
//  APIResponse.swift
//  InstaPanda
//
//  Created by Sebarina Xu on 8/5/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

/// API请求返回的结构体
public struct UTAPIResponse {
    /// 请求结果是否成功
    public var success : Bool
    /// 请求结果的数据，可能为nil
    public var result : AnyObject?
    /// 请求是否发生错误， 如果无错误则为nil
    public var error : NSError?
    
    public init() {
        success = false
    }
}

public struct UTDownloadResponse {
    /// 请求结果是否成功
    var success : Bool
    /// 请求结果的数据，可能为nil
    var result : NSURL?
    /// 请求是否发生错误， 如果无错误则为nil
    var error : NSError?
}