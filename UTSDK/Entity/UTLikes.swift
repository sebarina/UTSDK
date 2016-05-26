//
//  UTLikes.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/21/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public class UTLikes : NSObject {
    public var count : Int
    public var liked_by_user: Bool
    public var users : [UTUserInfo]
    
    public init(count: Int, liked_by_user: Bool, users: [UTUserInfo]) {
        self.count = count
        self.liked_by_user = liked_by_user
        self.users = users
    }
}