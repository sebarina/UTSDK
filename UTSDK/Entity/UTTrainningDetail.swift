//
//  UTTrainningDetail.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/24/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public enum UTTrainningAttentionType : String {
    case Disallowed = "disallowed"
    case Allowed = "allowed"
    case Warning = "warning"
    case None = "none"
}

public class UTTrainningAttention : NSObject {
    public var name : String
    public var type : UTTrainningAttentionType
    public var detail : String
    
    public init(name: String, type: UTTrainningAttentionType, detail: String) {
        self.name = name
        self.type = type
        self.detail = detail
    }
}

public class UTTrainningDetail: NSObject {
    public var trainning : UTTrainning
    public var workouts : [UTWorkout]
    public var teacher : UTTeacher
    public var reviews : [UTTrainningComment]
    public var isExclusive : Bool
    public var orgnization : UTOrgnization
    public var unlocked : Bool
    
    public init(trainning: UTTrainning, workouts: [UTWorkout], teacher: UTTeacher, reviews: [UTTrainningComment], orgnization: UTOrgnization, unlocked: Bool) {
        self.trainning = trainning
        self.workouts = workouts
        self.teacher = teacher
        self.reviews = reviews
        self.orgnization = orgnization
        if orgnization.type == .Third {
            isExclusive = true
        } else {
            isExclusive = false
        }
        self.unlocked = unlocked
        super.init()
    }

}