//
//  UTCircleType.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/21/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation


public class UTCircleType: NSObject {
    public var categoryId: String
    public var categoryName : String
    
    public init(categoryId: String, categoryName: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
    }
}