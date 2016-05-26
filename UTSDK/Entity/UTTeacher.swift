//
//  UTTeacher.swift
//  UTeacher
//
//  Created by Sebarina Xu on 1/3/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

public class UTTeacher: NSObject {
    public var id : String
    public var name : String
    public var desc : String
    public var detail : String
    public var avatar : String
    public var images : [String]
    public var videoUrl : String
    public var followed_by_user : Bool
    
    public init(id: String, name: String, desc: String, detail: String, avatar: String, images: [String], videoUrl: String, followed_by_user: Bool) {
        self.id = id
        self.name = name
        self.desc = desc
        self.detail = detail
        self.avatar = avatar
        self.images = images
        self.videoUrl = videoUrl
        self.followed_by_user = followed_by_user
        super.init()
    }
}