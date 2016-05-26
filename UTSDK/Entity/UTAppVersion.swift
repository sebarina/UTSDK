//
//  UTAppVersion.swift
//  UTeacher
//
//  Created by Sebarina Xu on 11/10/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

public struct UTAppVersion {
    /*!
    @ app的版本,对外公布的.
    
    @ eg: 2.5.0
    */
    public var versionName : String
    
    
    /*!
    @ app的build.
    */
   public  var buildName : String
    
    /*!
    @ 版本号数字
    
    @ 自增,eg:27
    */
    public var versionCode : Int
    
    /*!
    @ 是否强制更新
    */
    public var isForceUpdate : Bool
    
}