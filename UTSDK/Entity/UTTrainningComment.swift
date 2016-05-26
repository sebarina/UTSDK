//
//  UTTrainningComment.swift
//  UTeacher
//
//  Created by Sebarina Xu on 3/3/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

public enum TrainningCommentAttachmentType : String {
    case Topic = "topic"
    case Web = "web"
    case None = "none"
}

public class UTTrainningCommentAttachment : NSObject {
    public var type : TrainningCommentAttachmentType
    public var data : String
    
    init(type: String, data: String) {
        self.type = TrainningCommentAttachmentType(rawValue: type) ?? .None
        self.data = data
        super.init()
    }
}


public class UTTrainningComment: NSObject {
    public var id : String
    public var publisher : UTUserInfo
    public var grade : Int
    public var trainningId : String
    public var content : String
    public var createdAt : Double
    public var reply : UTTrainningCommentReply?
    
    public init(id: String, publisher: UTUserInfo, grade: Int, trainningId: String, content: String, createdAt: Double) {
        self.id = id
        self.publisher = publisher
        self.grade = grade
        self.trainningId = trainningId
        self.content = content
        self.createdAt = createdAt
        super.init()
    }
}


public class UTTrainningCommentReply : NSObject {
    public var id : String
    public var publisher : UTUserInfo
    public var content : String
    public var createdAt : Double
    public var attachment : UTTrainningCommentAttachment?
    
    public init(id: String, publisher: UTUserInfo, content: String, createdAt: Double) {
        self.id = id
        self.publisher = publisher
        self.content = content
        self.createdAt = createdAt
        super.init()
    }
}