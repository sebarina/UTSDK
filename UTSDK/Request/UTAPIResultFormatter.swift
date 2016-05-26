//
//  LFAPIResultFormater.swift
//  InstaPanda
//
//  Created by Sebarina Xu on 8/5/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public class UTAPIResultFormatter {
    public class func formatResponseData(response : NSData?, decoding: Bool) -> UTAPIResponse {
        var apiResponse : UTAPIResponse = UTAPIResponse()
        
        if response == nil {
            apiResponse.success = false
            apiResponse.result = nil
            apiResponse.error = NSError(domain: UTRuntime.currentDataMode().rawValue, code: 500, userInfo: ["error":"网络出错啦"])
        } else {
            let obj: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(response!, options: NSJSONReadingOptions.MutableContainers)
            if obj == nil {
                apiResponse.success = false
                apiResponse.result = nil
                apiResponse.error = NSError(domain: UTRuntime.currentDataMode().rawValue, code: 500, userInfo: ["error":"网络出错啦"])
            } else {
                if decoding {
                    let code = obj!.objectForKey("code") as? Int ?? 500
                    if code == 200 {
                        apiResponse.success = true
                        apiResponse.result = obj!.objectForKey("data")
                        apiResponse.error = nil
                    } else {
                        apiResponse.success = false
                        apiResponse.result = nil
                        apiResponse.error = NSError(domain: UTRuntime.currentDataMode().rawValue, code: code, userInfo: ["error":obj!.objectForKey("error") as? String ?? "服务程序开了个小差"])
                    }
                } else {
                    apiResponse.success = true
                    apiResponse.result = obj!
                    apiResponse.error = nil
                }
                
                
            }
        }
        
        
        return apiResponse
    }
}