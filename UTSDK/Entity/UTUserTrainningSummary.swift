//
//  UTUserSummary.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/9/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation


public class UTUserTrainningSummary : NSObject {
    /// 今天新增的皇冠数
    public var todayCount: Int
    /// 获得皇冠的数量
    public var count: Int
    /// 练习的时长，以秒为单位
    public var time: Double
    
    public var level : Int
    public var progress : Double
    public var coupon: UTCoupon?
    
    
    public init(todayCount: Int, count: Int, time: Double, level: Int, progress: Double) {
        
        self.todayCount = todayCount
        self.count = count
        self.time = time
        self.level = level
        self.progress = progress
        super.init()
    }
}