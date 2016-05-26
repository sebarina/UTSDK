
//
//  File.swift
//  UTeacher
//
//  Created by Sebarina Xu on 8/13/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public enum UTStepType : String {
    case Action = "action"
    case Rest = "rest"
}

public class UTStepLevel : NSObject {
    public var id : String
    public var name : String
    public var slug : String
    
    public init(id: String, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
        super.init()
    }
}

public class UTStepCategory : NSObject {
    public var id : String
    public var name : String
    public var slug : String
    
    public init(id: String, name: String, slug: String) {
        self.id = id
        self.name = name
        self.slug = slug
        super.init()
    }
}

public class UTStep : NSObject {
    public var id : String
    public var name : String
    public var thumbnail : String
    public var imageUrl : String
    public var videoUrl : String
    public var group : Int
    public var count : Int
    public var duration : Int
    public var type : UTStepType
    public var points : String
    public var benefits : String
    public var attention : String
    public var level : UTStepLevel
    public var category : UTStepCategory
    
    public init(id: String, name: String,thumbnail: String, imageUrl: String, videoUrl: String, group: Int, count: Int, duration: Int, type: UTStepType, points: String, attention: String, benefits: String, level: UTStepLevel, category: UTStepCategory) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
        self.imageUrl = imageUrl
        self.videoUrl = videoUrl
        self.group = group
        self.count = count
        self.duration = duration
        self.type = type
        self.points = points
        self.attention = attention
        self.benefits = benefits
        self.level = level
        self.category = category
        super.init()
    }
}