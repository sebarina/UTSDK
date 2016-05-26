//
//  DeviceService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 4/21/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import UIKit


public class DeviceService: NSObject {
    class func updateDeviceInfo(deviceToken: String, block: ((response: UTAPIResponse) -> Void)?) {
        let deviceId = UTRuntime.deviceId
        if !deviceId.isEmpty {
            let needAuth : Bool = UTRuntime.currentUser() != nil
            let config = UTAPIConfig(apiName: "update", apiNamespace: "device", apiVersion: "100", apiIsNeedAuth: needAuth)
            let request = UTAPIUtil.getAPIRequestByConfig(config)
            
            request.requestParams = [
                "deviceId": deviceId,
                "deviceToken": deviceToken
            ]
            request.startRequestWithMethod(.POST, callback: { (response: UTAPIResponse) in
                block?(response: response)
            })
        }
        
    }
}