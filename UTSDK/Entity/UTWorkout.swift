//
//  UTCourseDetail.swift
//  UTeacher
//
//  Created by Sebarina Xu on 7/8/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation


public class UTWorkout : NSObject {
    public var id : String
    public var name : String
    /// 动作总个数
    public var count : Int
    /// 所有动作的ids
    public var steps : [String]
    public var duration : Int
    public var credit : Int
    /// 训练相关的理论知识，暂时没有
    public var courses : [AnyObject]?
    
    public var videoUrl : String
    
    public init(id: String, name: String, count: Int, steps: [String], duration: Int, credit: Int, videoUrl: String) {
        self.id = id
        self.name = name
        self.count = count
        self.steps = steps
        self.duration = duration
        self.credit = credit
        self.videoUrl = videoUrl
        super.init()
    }
}
