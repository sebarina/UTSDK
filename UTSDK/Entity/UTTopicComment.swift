//
//  UTTopicComment.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/22/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation


public class UTTopicComment : NSObject {
    public var id : String
    public var content : String
    public var publisher : UTUserInfo
    public var receiver : UTUserInfo?
    public var likedCount : Int
    public var liked_by_user : Bool
    public var createdAt : Double
    
    public init(id: String, content: String, publisher: UTUserInfo, receiver: UTUserInfo?, likedCount: Int, liked_by_user: Bool, createdAt: Double) {
        self.id = id
        self.content = content
        self.publisher = publisher
        self.receiver = receiver
        self.likedCount = likedCount
        self.liked_by_user = liked_by_user
        self.createdAt = createdAt
        
        super.init()
    }
}