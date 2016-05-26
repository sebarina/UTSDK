//
//  UTCourse.swift
//  UTeacher
//
//  Created by Sebarina Xu on 7/6/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation


public enum UTDifficulty : Int {
    case Zero = 0
    case One = 1
    case Two = 2
    case Three = 3
}

public enum UTSexCategory : String {
    case Male = "m"
    case Female = "f"
    case General = "g"
}

public enum UTTrainningStatus : String {
    case Trainning = "trainning"
    case Aborted = "aborted"
    case Finished = "finished"
}

public enum UTTrainningType : String {
    case Plan = "plan"
    case Once = "once"
}

public enum UTTrainningLabel : String {
    case New = "new"
    case Hot = "hot"
    case Exclusive = "exclusive"
    case None = "none"
}

public class UTTrainningTag : NSObject {
    public var name : String
    public var priority : Int
    
    init(name: String, priority: Int) {
        self.name = name
        self.priority = priority
    }
}

public class UTTrainning : NSObject
{
    public var id : String
    public var name : String
    public var desc : String
    public var imageUrl : String
    public var thumbnail : String
    public var previewVideo : String
    public var type : UTTrainningType
    public var difficulty : UTDifficulty
    public var joined : Bool
    public var total : Int
    public var complete : Int
    public var credit : Int
    public var attendCount : Int
    public var workouts : [String]
    public var duration : Int
    public var tags : [UTTrainningTag]
    public var newImageUrls : [String: String]
    public var label : UTTrainningLabel
    public var attentions : [UTTrainningAttention]
    public var price : Int
    
    
    
    public init(id: String, name: String, desc: String, imageUrl: String, thumbnail: String, type: UTTrainningType, difficulty: UTDifficulty, joined: Bool, total: Int, complete: Int, credit: Int, attendCount: Int, previewVideo: String, workouts: [String], duration: Int, tags: [UTTrainningTag], newImageUrls: [String: String], label: UTTrainningLabel, attentions : [UTTrainningAttention], price: Int) {
        self.id = id
        self.name = name
        self.desc = desc
        self.imageUrl = imageUrl
        self.thumbnail = thumbnail
        self.type = type
        self.difficulty = difficulty
        self.joined = joined
        self.total = total
        self.complete = complete
        self.credit = credit
        self.attendCount = attendCount
        self.previewVideo = previewVideo
        self.workouts = workouts
        self.duration = duration
        self.tags = tags
        self.newImageUrls = newImageUrls
        self.label = label
        self.attentions = attentions
        self.price = price
        super.init()
    }
    
}