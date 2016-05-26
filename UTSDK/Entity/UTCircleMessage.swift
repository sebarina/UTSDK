//
//  UTCircleMessage.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/28/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public enum UTCircleMessageType : String {
    case Comment = "comment"
    case Reply = "reply"
    case Follow = "follow"
    case LikeTopic = "liketopic"
    case LikeComment = "likecomment"
    case ReplyTrainning = "replytrainning"
    case Trainning = "trainning"
    case Topic = "topic"
    case Activity = "activity"
}

public enum UTMessageStatus : String {
    case Read = "read"
    case Unread = "unread"
}

public class UTCircleMessage: NSObject {
    public var id : String
    public var sender : UTUserInfo
    public var messageId : String
    public var name : String
    public var content: String
    public var type : UTCircleMessageType
    public var categoryId : String
    public var status : UTMessageStatus
    public var createdAt : Double
    public var imageUrl : String
    
    public init(id: String, sender: UTUserInfo, messageId: String, name: String, content: String, type: UTCircleMessageType, categoryId: String, status: UTMessageStatus, createdAt: Double, imageUrl: String) {
        self.id = id
        self.sender = sender
        self.messageId = messageId
        self.name = name
        self.content = content
        self.type = type
        self.categoryId = categoryId
        self.status = status
        self.createdAt = createdAt
        self.imageUrl = imageUrl
        super.init()
    }
}