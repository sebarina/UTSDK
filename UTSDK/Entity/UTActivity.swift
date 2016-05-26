//
//  UTActivity.swift
//  UTeacher
//
//  Created by Sebarina Xu on 2/26/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

public enum UTActivityType : String {
    case Topic = "topic"
    case Trainning = "trainning"
    case Activity = "activity"
    case None = "none"
}

public class UTActivity : NSObject {
    public var id : String
    public var type : UTActivityType
    public var imageUrl : String
    public var data : String
    
    public init(id: String, type: UTActivityType, imageUrl: String, data: String) {
        self.id = id
        self.type = type
        self.imageUrl = imageUrl
        self.data = data
        super.init()
    }
}