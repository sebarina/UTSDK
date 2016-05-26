//
//  UTTrainningTrack.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/25/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation


public class UTTrainningTrack: NSObject{
    public var id : String
    public var user : UTUserInfo
    public var createdAt : Double
    public var complete : Int
    public var credit : Int
    public var duration : Double
    public var trainningId : String
    public var trainningName : String
    
    public init(id: String, user: UTUserInfo, createdAt: Double, complete: Int, credit: Int, duration: Double, trainningId: String, trainningName: String) {
        self.id = id
        self.user = user
        self.createdAt = createdAt
        self.complete = complete
        self.trainningId = trainningId
        self.credit = credit
        self.duration = duration
        self.trainningName = trainningName
        super.init()
    }
    
}