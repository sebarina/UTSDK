//
//  APIRequest.swift
//  InstaPanda
//
//  Created by Sebarina Xu on 8/5/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation
import UTNetwork


public typealias LFAPI_Request_Callback = UTAPIResponse -> Void

public enum UTAPIRequestMethod : String {
    case GET = "GET"
    case POST = "POST"
}

/// API Request class
public class UTAPIRequest {
    /// 请求url
    var urlString : String
    /// 网络请求session
    var session : UTNetworkSession
    /// 请求是否需要access token
    var isNeedAuth : Bool = false
    
    /// 请求参数
    var requestParams : [String:AnyObject]?
    
    /// 是否需要借下返回的json数据，默认为true
    var needDecodeResponse : Bool = true
    
    public static let APPID : String = "ut1033461808"
    
    public init(url: String) {
        urlString = url
        session = UTSessionManager.getSession(UTRuntime.currentDataMode().rawValue)
    }
    
    public init(url: String, baseUrl: String) {
        urlString = url
        session = UTSessionManager.getSession(baseUrl)
    }
    
    public func processCommonParams(method: UTAPIRequestMethod) {
        if requestParams == nil {
            requestParams = [String : AnyObject]()
        }
        requestParams!["timestamp"] = String(Int(NSDate().timeIntervalSince1970))
        requestParams!["client"] = UIDevice.currentDevice().model
        requestParams!["appId"] = UTAPIRequest.APPID
        if isNeedAuth {
            requestParams!["access_token"] = UTRuntime.currentUser()?.accessToken ?? ""
        }
        if requestParams!["deviceId"] == nil {
            requestParams!["deviceId"] = UTRuntime.deviceId
        }
        
        
        
        let signature = UTAPIUtil.generateRequestSignature(UTRuntime.currentDataMode().rawValue + urlString, method: method, requestParams: requestParams!)
    
        requestParams!["signature"] = signature
    }
    
    public class func startRawAPIRequest(url: String, method: UTAPIRequestMethod, params: [String: AnyObject]?, headers: [String: String]?, callback: LFAPI_Request_Callback) {
        let session = UTNetworkSession(baseUrl: "", timeout: 10)
        session.startOperationWithUrlString(url, method: method.rawValue, params: params, header: headers, success: { (obj: AnyObject?, response: NSURLResponse) in
            callback(UTAPIResultFormatter.formatResponseData(obj as? NSData, decoding: false))
        }) { (error: NSError, response: NSURLResponse) in
            var responseData = UTAPIResponse()
            responseData.success = false
            responseData.result = nil
            responseData.error = error
            callback(responseData)
        }
    }
    
    /**
    开始一个API请求
    
    - parameter requestMethod:   请求方法（GET，POST）
    - parameter requestParams:   请求参数
    - parameter requestProtocol: 请求协议（HTTP，HTTPS）
    - parameter callback:        请求回调 LFAPI_Request_Callback
    */
    func startRequestWithMethod(requestMethod : UTAPIRequestMethod, callback: LFAPI_Request_Callback) {
        processCommonParams(requestMethod)
        
        var header : [String: String]?
        if requestMethod == .POST && requestParams != nil {
            header = ["Content-Type" : "application/json"]
        }
        
        session.startOperationWithUrlString(urlString, method: requestMethod.rawValue, params: requestParams, header: header, success: { (obj: AnyObject?, response: NSURLResponse) in
            callback(UTAPIResultFormatter.formatResponseData(obj as? NSData, decoding: self.needDecodeResponse))
        }) { (error: NSError, response: NSURLResponse) in
            var responseData = UTAPIResponse()
            responseData.success = false
            responseData.result = nil
            responseData.error = error
            callback(responseData)
        }
        
    }
//    
//    /**
//    开始一个上传文件的请求
//    
//    - parameter requestProtocol: 请求的协议（HTTP，HTTPS）
//    - parameter fileData:        上传的文件数据
//    - parameter callback:        请求回调 LFAPI_Request_Callback
//    */
//    func startUploadWithProtocol(fileData: NSData, filename: String,  callback: LFAPI_Request_Callback) {
//        let requestProtocol : UTAPIRequestProtocol = (UTRuntime.currentDataMode() == .Product || UTRuntime.currentDataMode() == .DevProd) ? .HTTPS : .HTTP
//        session.startUploadWithData(requestProtocol.rawValue + urlString, fileData: fileData, filename: filename, method: .POST, block: {
//            (data: AnyObject?, requestOperation: AFHTTPRequestOperation!, error: NSError?) in
//            LFLogger.logInfo("======================= Response Data =========================")
//            LFLogger.logInfo(requestOperation.responseString)
//            if error == nil {
//                callback(UTAPIResultFormatter.formatResponseData(data as? NSData, decoding: self.needDecodeResponse))
//            } else {
//                var responseData = UTAPIResponse()
//                responseData.success = false
//                responseData.result = nil
//                responseData.error = error
//                callback(responseData)
//            }
//        })
//    }
    
}