//
//  UTCoupon.swift
//  UTeacher
//
//  Created by Sebarina Xu on 5/17/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

public enum UTCouponRangeType : String {
    case All = "all"
    case Specific = "specific"
    case None = "none"
}


public class UTCoupon : NSObject {
    public var id : String
    public var value : Int
    public var atLeast : Int
    public var rangeType : UTCouponRangeType
    public var rangeValues : [String]
    public var usage : String
    public var price : Int
    public var code : String
    public var startAt : Double
    public var endAt : Double
    public var stock : Int
    public var quota : Int
    public var imageUrl : String
    public var expiring : Bool = false
    public var expired : Bool = false
    
    public init(id: String, value: Int, atLeast: Int, rangeType: UTCouponRangeType, rangeValues: [String], usage: String, price: Int, code: String, startAt: Double, endAt: Double, stock: Int, quota: Int, imageUrl: String) {
        self.id = id
        self.value = value
        self.atLeast = atLeast
        self.rangeType = rangeType
        self.rangeValues = rangeValues
        self.usage = usage
        self.price = price
        self.code = code
        self.startAt = startAt
        self.endAt = endAt
        self.stock = stock
        self.quota = quota
        self.imageUrl = imageUrl
        super.init()
        
        if endAt < NSDate().timeIntervalSince1970 {
            expired = true
        } else if endAt < NSDate().timeIntervalSince1970 + 24*3600 {
            expiring = true
        }
        
    }

    
}