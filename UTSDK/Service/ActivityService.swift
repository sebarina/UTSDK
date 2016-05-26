//
//  ActivityService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 2/26/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

@objc public protocol ActivityServiceDelegate {
    optional func didGetBannerActivities(success: Bool, data: [UTActivity]?, error: String?)
}

public class ActivityService : NSObject {
    
    private weak var delegate : ActivityServiceDelegate?
    
    public init(delegate: ActivityServiceDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    public func getBannerActivities() {
        let config = UTAPIConfig(apiName: "banner", apiNamespace: "activity", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        
        request.startRequestWithMethod(.POST) {
            (response:UTAPIResponse) in
            if response.success {
                if let array = response.result as? [AnyObject] {
                    var activities : [UTActivity] = [UTActivity]()
                    for obj in array {
                        activities.append(self.processActivityResult(obj))
                    }
                    self.delegate?.didGetBannerActivities?(true, data: activities, error: nil)
                } else {
                    self.delegate?.didGetBannerActivities?(false, data: nil, error: "获取失败")
                }
            } else {
                self.delegate?.didGetBannerActivities?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public func processActivityResult(obj: AnyObject) -> UTActivity {
        let id : String = obj.objectForKey("objectId") as? String ?? ""
        let type : UTActivityType = UTActivityType(rawValue: obj.objectForKey("type") as? String ?? "none") ?? .None
        let imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
        let data : String = obj.objectForKey("data") as? String ?? ""
        return UTActivity(id: id, type: type, imageUrl: imageUrl, data: data)
    }
    
}