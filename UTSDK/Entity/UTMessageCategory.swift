//
//  UTMessageCategory.swift
//  UTeacher
//
//  Created by Sebarina Xu on 3/1/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation


public class UTMessageCategory : NSObject {
    public var id : String
    public var name : String
    public var unreadCount : Int
    public var slug : String
    
    public init(id: String, name: String, count: Int, slug: String) {
        self.id = id
        self.name = name
        self.unreadCount = count
        self.slug = slug
        super.init()
    }

}