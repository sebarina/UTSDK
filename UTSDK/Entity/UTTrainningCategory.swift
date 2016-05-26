//
//  UTTrainningCategory.swift
//  UTeacher
//
//  Created by Sebarina Xu on 4/14/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

public class UTTrainningCategory: NSObject {
    public var id : String
    public var name : String
    public var desc : String
    public var imageUrl : String
    public var trainningCount : Int
    
    public init(id: String, name: String, desc: String, imageUrl: String, count: Int) {
        self.id = id
        self.name = name
        self.desc = desc
        self.imageUrl = imageUrl
        self.trainningCount = count
        super.init()
    }
}