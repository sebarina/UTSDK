//
//  ApplicationService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 11/10/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

@objc public  protocol ApplicationServiceDelegate {
    optional func didGetApplicationConfig(success: Bool, data: UTApplication?, error: String?)
}

public class ApplicationService : NSObject {
    
    private weak var delegate: ApplicationServiceDelegate?
    
    override public init() {
        super.init()
    }
    
    public init(delegate: ApplicationServiceDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    public func getApplicationConfig() {
        let config = UTAPIConfig(apiName: "configuration", apiNamespace: "application", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.startRequestWithMethod(.GET, callback: {
            (response: UTAPIResponse) in
            if response.success {
                if response.result != nil {
                    let appConfig = ApplicationService.processApplicationResult(response.result!)
                    UTRuntime.setCurrentApplication(appConfig)
                    self.delegate?.didGetApplicationConfig?(true, data: appConfig, error: nil)
                } else {
                    self.delegate?.didGetApplicationConfig?(false, data: nil, error: "Server error")
                }
            } else {
                self.delegate?.didGetApplicationConfig?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
        
    }
    
    public class func processApplicationResult(obj: AnyObject) -> UTApplication {
        let verCode: Int = obj.objectForKey("verCode") as? Int ?? 0
        let downloadUrl : String = obj.objectForKey("downloadUrl") as? String ?? ""
        let terms : String = obj.objectForKey("terms") as? String ?? ""
        let privacy : String = obj.objectForKey("privacy") as? String ?? ""
        let topicLength : Int = obj.objectForKey("topicLength") as? Int ?? 140
        
        let trainningShare : UTShareConfig = processShareResult(obj.objectForKey("share")?.objectForKey("trainning"))
        let resultShare : UTShareConfig = processShareResult(obj.objectForKey("share")?.objectForKey("result"))
        let topicShare : UTShareConfig = processShareResult(obj.objectForKey("share")?.objectForKey("topic"))
        let appShare : UTShareConfig = processShareResult(obj.objectForKey("share")?.objectForKey("app"))
        
        var marketUrl : String = obj.objectForKey("market")?.objectForKey("imageUrl") as? String ?? ""
        if !marketUrl.isEmpty {
            marketUrl += "?imageView2/0/format/webp"
        }
        let duration : Double = obj.objectForKey("market")?.objectForKey("duration") as? Double ?? 0
        
        let descriptions : [String] = obj.objectForKey("descriptions") as? [String] ?? []
        
        let couponHelp : String = obj.objectForKey("couponHelp") as? String ?? ""
        
        return UTApplication(verCode: verCode, downloadUrl: downloadUrl, terms: terms, privacy: privacy, couponHelp: couponHelp, topicLength: topicLength, trainningShare: trainningShare, resultShare: resultShare, topicShare: topicShare, appShare: appShare, market: UTMarketConfig(imageUrl: marketUrl, duration: duration), descriptions: descriptions)
    }
    
    public class func processShareResult(obj: AnyObject?) -> UTShareConfig {
        let title : String = obj?.objectForKey("title") as? String ?? ""
        let desc : String = obj?.objectForKey("desc") as? String ?? ""
        let webUrl : String = obj?.objectForKey("url") as? String ?? ""
        return UTShareConfig(title: title, desc: desc, webUrl: webUrl)
    }
}