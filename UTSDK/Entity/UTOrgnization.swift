//
//  UTOrgnization.swift
//  UTeacher
//
//  Created by Sebarina Xu on 4/14/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

public enum UTOrgnizationType : String {
    case Official = "official"
    case Third = "third"
    case None = "none"
}

public class UTOrgnization: NSObject {
    public var id : String
    public var name : String
    public var desc : String
    public var logo : String
    public var imageUrl : String
    public var userId : String
    public var newTrainning : String
    public var showingText : String
    public var teachers : [UTTeacher]
    public var type : UTOrgnizationType
    public var trainningCount : Int
    
    public var followed_by_user : Bool
    
    
    public init(id: String, name: String, desc: String, logo: String, imageUrl: String, userId: String, new: String, show: String, teachers: [UTTeacher], type: UTOrgnizationType, count: Int, followed_by_user: Bool) {
        self.id = id
        self.name = name
        self.desc = desc
        self.logo = logo
        self.imageUrl = imageUrl
        self.userId = userId
        self.newTrainning = new
        self.showingText = show
        self.teachers = teachers
        self.type = type
        self.trainningCount = count
        self.followed_by_user = followed_by_user
        super.init()
    }
}