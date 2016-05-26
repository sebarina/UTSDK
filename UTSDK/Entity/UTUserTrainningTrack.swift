//
//  UTUserTrainningTrack.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/27/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public class UTUserTrainningTrack: NSObject {
    public var id : String
    public var trainningId : String
    public var trainningName : String
    public var complete : Int
    public var duration : Double
    public var credit : Int
    public var createdAt : Double
    
    public init(id: String, trainningId: String, trainningName: String, complete: Int, duration: Double, credit: Int, createdAt: Double) {
        self.id = id
        self.trainningId = trainningId
        self.trainningName = trainningName
        self.complete = complete
        self.duration = duration
        self.credit = credit
        self.createdAt = createdAt
    }
}