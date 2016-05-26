//
//  UTDevice.swift
//  UTeacher
//
//  Created by Sebarina Xu on 8/17/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public class UTDevice {
    public var id : String
    public var name : String
    public var imageUrl : String
    
    public init(id: String, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}