//
//  UTTopic.swift
//  UTeacher
//
//  Created by Sebarina Xu on 8/16/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public enum UTTopicCategory {
    case All
    case Hot
    case Latest
    case User
}

public class UTTopic : NSObject {
    public var id : String
    public var content : String
    public var images : [String]
    public var commentCount : Int
    public var likeCount : Int
    public var createdAt : Double
    public var publisher : UTUserInfo
    public var likes : UTLikes
    public var circle : UTCircle?
    public var isVideo : Bool = false
    public var videoUrl : String
    
    public init(id: String, content: String, images: [String], commentCount: Int, likeCount: Int, createdAt: Double, publisher: UTUserInfo, likes: UTLikes, videoUrl: String) {
        self.id = id
        self.content = content
        self.images = images
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.createdAt = createdAt
        self.publisher = publisher
        self.likes = likes
        self.videoUrl = videoUrl
        if videoUrl.isEmpty {
            self.isVideo = false
        } else {
            self.isVideo = true
        }
        super.init()
    }
    
}