//
//  UTAPIUtil.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/2/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation
import UTCommonCryto

public class UTAPIUtil {
    public class func getAPIRequestByConfig(config: UTAPIConfig) -> UTAPIRequest {
        let urlString : String = "/\(config.apiVersion)/\(config.apiNamespace)/\(config.apiName)"
        let request : UTAPIRequest = UTAPIRequest(url: urlString)
        request.isNeedAuth = config.apiIsNeedAuth
        return request
    }
    
    public class func getAPIRequestByName(name: String, version: String, namespace: String, needAuth: Bool) -> UTAPIRequest {
        
        let apiConfig : UTAPIConfig = UTAPIConfig(apiName: name, apiNamespace: namespace, apiVersion: version, apiIsNeedAuth: needAuth)
        
        return getAPIRequestByConfig(apiConfig)
    }
    
    public class func getURLStringByName(name: String, version: String, namespace: String) -> String {
        return  "/" + version + "/" + namespace + "/" + name
    }
    
    public class func generateRequestSignature(urlString: String, method: UTAPIRequestMethod, requestParams : [String: AnyObject]?) -> String {
        var originStr : String = urlString + method.rawValue
        
        if let params = requestParams {
            originStr += getDictionayString(params)
        }

        return originStr.hmac(.MD5, key: UTAPIRequest.APPID.md5())
        
    }
    
    public class func getObjectString(obj: AnyObject) -> String {
        var value : String = ""
        if let dictValue = obj as? [String: AnyObject] {
            value = getDictionayString(dictValue)
        } else if let arrayValue = obj as? [AnyObject] {
            for temp in arrayValue {
                value += getObjectString(temp)
            }
        } else {
            value = "\(obj)"
        }
        
        return value
    }
    
    public class func getDictionayString(dict: [String: AnyObject]) -> String {
        let keys = dict.keys.sort()
        var dictString = ""
        for key in keys {
            let value = dict[key]!
            dictString += key
            dictString += getObjectString(value)
        }
        return dictString
    }
}