//
//  LFUser.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/2/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public class UTUser: NSObject {
    public var userId : String
    public var accessToken : String
    public var permissions : [String]
    
    public init(userId: String, accessToken: String, permissions: [String]) {
        self.userId = userId
        self.accessToken = accessToken
        self.permissions = permissions
        super.init()
    }
}