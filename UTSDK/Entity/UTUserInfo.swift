//
//  UTUserInfo.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/20/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public class UTUserInfo : NSObject {
    public var userId : String
    public var nickname : String
    public var avatar : String
    public var desc : String
    public var sex : UTSexCategory
    public var city : String
    public var birthday : Double
    public var followed_by_user : Bool
    public var followerCount : Int // 粉丝
    public var followingCount : Int // 关注数
    public var credit : Int
    public var topicCount : Int
    public var crown : Int
    
    public init(userId: String, nickname: String, avatar: String, desc: String, sex: UTSexCategory, city: String, birthday: Double, followed_by_user: Bool, followerCount: Int, followingCount: Int, credit: Int, topicCount: Int, crown: Int) {
        self.userId = userId
        self.nickname = nickname
        self.avatar = avatar
        self.desc = desc
        self.sex = sex
        self.city = city
        self.birthday = birthday
        self.followed_by_user = followed_by_user
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.credit = credit
        self.topicCount = topicCount
        self.crown = crown
        super.init()
    }
    
}