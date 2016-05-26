//
//  UTTopicDetail.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/22/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation


public class UTTopicDetail : NSObject {
    public var topic : UTTopic
    public var comments : [UTTopicComment]
    
    public init(topic: UTTopic, comments: [UTTopicComment]) {
        self.topic = topic
        self.comments = comments
        super.init()
    }
}