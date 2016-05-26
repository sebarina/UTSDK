//
//  UTCircleDetail.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/24/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public class UTCircleDetail : NSObject {
    public var circle : UTCircle
    public var topics : [UTTopic]
    
    public init(circle: UTCircle, topics: [UTTopic]) {
        self.circle = circle
        self.topics = topics
    }
}