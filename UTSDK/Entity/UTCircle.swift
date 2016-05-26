//
//  UTCircle.swift
//  UTeacher
//
//  Created by Sebarina Xu on 8/14/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public class UTCircle : NSObject {
    public var id : String
    public var name : String
    public var imageUrl : String
    public var thumbnail : String
    public var desc : String
    public var userCount : Int
    public var topicCount : Int
    public var joined : Bool
    
    public init(id: String, name: String, imageUrl: String, thumbnail: String, desc: String, userCount: Int, topicCount: Int, joined: Bool) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.thumbnail = thumbnail
        self.desc = desc
        self.userCount = userCount
        self.topicCount = topicCount
        self.joined = joined
    }
}