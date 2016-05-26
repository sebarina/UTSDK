//
//  UTApplication.swift
//  UTeacher
//
//  Created by Sebarina Xu on 11/10/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public class UTShareConfig : NSObject {
    public var title : String
    public var desc : String
    public var webUrl : String
    
    public init(title: String, desc: String, webUrl: String) {
        self.title = title
        self.desc = desc
        self.webUrl = webUrl
    }
}

public class UTMarketConfig : NSObject {
    public var imageUrl : String
    public var duration : Double
    
    public init(imageUrl: String, duration: Double) {
        self.imageUrl = imageUrl
        self.duration = duration
        super.init()
    }
}

public class UTApplication : NSObject {
    public var verCode: Int
    public var downloadUrl : String
    public var terms : String
    public var privacy : String
    public var couponHelp : String
    public var topicLength : Int
    public var appDescriptions : [String]
    public var trainningShare : UTShareConfig
    public var resultShare : UTShareConfig
    public var topicShare : UTShareConfig
    public var appShare : UTShareConfig
    public var market : UTMarketConfig
    
    
    public init(verCode: Int, downloadUrl: String, terms: String, privacy: String, couponHelp: String, topicLength: Int, trainningShare: UTShareConfig, resultShare: UTShareConfig, topicShare: UTShareConfig, appShare: UTShareConfig, market:UTMarketConfig, descriptions: [String]) {
        self.verCode = verCode
        self.downloadUrl = downloadUrl
        self.terms = terms
        self.privacy = privacy
        self.couponHelp = couponHelp
        self.topicLength = topicLength
        self.trainningShare = trainningShare
        self.resultShare = resultShare
        self.topicShare = topicShare
        self.appShare = appShare
        self.market = market
        self.appDescriptions = descriptions
    }
}