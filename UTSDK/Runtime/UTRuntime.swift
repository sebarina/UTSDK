//
//  UTRuntime.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/2/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation
import UTKeychainSecurity

enum UTAPIDataMode : String {
    case Loacal = "http://127.0.0.1:3000"
    case Dev = "http://stg-uteacher-test.leanapp.cn"
    case DevProd = "https://uteacher-test.leanapp.cn"
    case DevProduct = "http://stg-uteacher.leanapp.cn"
    case Product = "http://uteacher.leanapp.cn"
}

class UTRuntime {
    private static var _currentUser : UTUser?
    private static var _currentApplication : UTApplication?
    private static var _security : UTKeychainSecurity = UTKeychainSecurity(group: "", service: "UTeacher Service")
    
    static var deviceId : String {
        get {
            return UIDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        }
    }
    
    static var currentVersion : UTAppVersion {
        get {
            let versionName : String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String ?? "1.0.0"
            let buildName : String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String ?? "1.0.0"
            
            let versionCode : Int = NSBundle.mainBundle().objectForInfoDictionaryKey("verCode") as? Int ?? 1
            
            let isForceUpgrade = false
            
            return UTAppVersion(versionName: versionName, buildName: buildName, versionCode: versionCode,  isForceUpdate: isForceUpgrade)
        }
    }
    
    class func currentDataMode() -> UTAPIDataMode {
        let mode: String = NSBundle.mainBundle().objectForInfoDictionaryKey("dataMode") as? String ?? ""
        if mode == "online" {
            return UTAPIDataMode.Product
        } else if mode == "dev" {
            return UTAPIDataMode.Dev
        } else if mode == "devprod" {
            return UTAPIDataMode.DevProd
        } else if mode == "devonline" {
            return UTAPIDataMode.DevProduct
        }
        return UTAPIDataMode.Loacal
    }
    
    class func currentApplication() -> UTApplication {
        if _currentApplication == nil {
            let verCode : Int = NSBundle.mainBundle().objectForInfoDictionaryKey("verCode") as? Int ?? 0
            let share : UTShareConfig = UTShareConfig(title: "", desc: "", webUrl: "")
            
            return UTApplication(verCode: verCode, downloadUrl: "http://www.uteacher.me", terms: "", privacy: "", couponHelp: "", topicLength: 140, trainningShare: share, resultShare: share, topicShare: share, appShare: share, market: UTMarketConfig(imageUrl: "", duration: 0), descriptions: [])
        }
        return _currentApplication!
    }
    
    class func setCurrentApplication(application: UTApplication) {
        _currentApplication = application
        
    }
    
    class func currentUser() -> UTUser? {
        if _currentUser != nil {
            return _currentUser!
        }
        let userId: String? = _security.securityGetValueByKey("userId")
        let accessToken : String? = _security.securityGetValueByKey("accessToken")
        let permissions : [String]? = _security.securityGetArrayByKey("permissions") as? [String]
    
        
        if userId == nil || accessToken == nil {
            return nil
        }
        
        return UTUser(userId: userId!, accessToken: accessToken!, permissions: permissions ?? [])
        
    }
    
    class func setCurrentUser(user: UTUser) {
        _security.securitySaveValue(user.userId, key: "userId")
        _security.securitySaveValue(user.accessToken, key: "accessToken")
        if !user.permissions.isEmpty {
            _security.securitySaveArray(NSArray(array: user.permissions), key: "permissions")
        }
//        UMessage.addTag(user.userId, response: nil)
        _currentUser = user
    }
    
    class func deleteCurrentUser() {
        _security.securityDeleteItemByKey("userId")
        _security.securityDeleteItemByKey("accessToken")
        _security.securityDeleteItemByKey("permissions")
        _currentUser = nil
//        UMessage.removeAllTags(nil)
    }

}