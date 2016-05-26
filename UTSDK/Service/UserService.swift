//
//  UserService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/16/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

@objc protocol UserServiceDelegate {
    optional func didGetUserFinishedTrainnings(success: Bool, data: [UTTrainning]?, error: String?)
    optional func didGetUserInfo(success: Bool, data: UTUserInfo?, error: String?)
    optional func didGetUserTrainningTracks(success: Bool, page: Int, hasNext: Bool, data: [UTUserTrainningTrack]?, error: String?)
    optional func didGetUserCircles(success: Bool, data: [UTCircle]?, error: String?)
    optional func didGetUserFollowers(success: Bool, page: Int, hasNext: Bool, data: [UTUserInfo]?, error: String?)
    optional func didGetUserFollowings(success: Bool, page: Int, hasNext: Bool, data: [UTUserInfo]?, error: String?)
    optional func didFollowedUser(success: Bool, userId: String, error: String?)
    optional func didUnfollowedUser(success: Bool, userId: String, error: String?)
    optional func didUpdateUserInformation(success: Bool, information: [String: AnyObject]?, error: String?)
    
}

class UserService : NSObject {
    private weak var delegate : UserServiceDelegate?
    static let pageCount : Int = 15
    
    init(delegate: UserServiceDelegate) {
        self.delegate = delegate
        super.init()
    }
    
//    func getUserFinishedTrainnings() {
//        if UTRuntime.currentUser() == nil {
//            return
//        }
//        let config = UTAPIConfig(apiName: "trainnings", apiNamespace: "user", apiVersion: "1", apiIsNeedAuth: true)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["status": "finished"]
//        
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                
//            } else {
//                
//            }
//        })
//        
//    }
    
    func getUserTrainningTracks(page: Int, userId: String) {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: "trainning.tracks", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": UserService.pageCount,
            "id": userId
        ]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array = response.result?.objectForKey("data") as? [AnyObject]
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                if array != nil {
                    self.delegate?.didGetUserTrainningTracks?(true, page: page, hasNext: hasNext, data: self.processUserTrainningTrackResults(array!), error: nil)
                } else {
                    self.delegate?.didGetUserTrainningTracks?(false, page: page, hasNext: false, data: nil, error: "Failed to get user trainning tracks")
                }
            } else {
                self.delegate?.didGetUserTrainningTracks?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
//    func getUserCircles(userId: String) {
//        let needAuth : Bool = (UTRuntime.currentUser() != nil)
//        let config = UTAPIConfig(apiName: "circles", apiNamespace: "user", apiVersion: "1", apiIsNeedAuth: needAuth)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = [
//            "id": userId
//        ]
//        
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let array = response.result as? [AnyObject]
//                if array != nil {
//                    self.delegate?.didGetUserCircles?(true, data: CircleService.processCirclesResult(array!), error: nil)
//                } else {
//                    self.delegate?.didGetUserCircles?(false, data: nil, error: "Failed to get user circles")
//                }
//            } else {
//                self.delegate?.didGetUserCircles?(false, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
    
    func getUserInfo(userId: String) {
        let needAuth : Bool = (UTRuntime.currentUser() != nil)
        let config = UTAPIConfig(apiName: "information", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": userId]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didGetUserInfo?(true, data: UserService.processUserInfoResult(response.result), error: nil)
            } else {
                self.delegate?.didGetUserInfo?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
            
        })
    }
    
    func getUserFollowers(page: Int, userId: String) {
        let needAuth : Bool = (UTRuntime.currentUser() != nil)
        let config = UTAPIConfig(apiName: "followers", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": UserService.pageCount,
            "id": userId
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array : [AnyObject]? = response.result?.objectForKey("followers") as? [AnyObject]
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                if array != nil {
                    var data = [UTUserInfo]()
                    for obj in array! {
                        data.append(UserService.processUserInfoResult(obj))
                    }
                    
                    self.delegate?.didGetUserFollowers?(true, page: page, hasNext:hasNext, data: data, error: nil)
                } else {
                    self.delegate?.didGetUserFollowers?(false, page: page, hasNext: false, data: nil, error: "Failed to get user followers")
                }
                
            } else {
                self.delegate?.didGetUserFollowers?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
            
        })
    }
    
    func getUserFollowings(page: Int, userId: String) {
        let needAuth : Bool = (UTRuntime.currentUser() != nil)
        let config = UTAPIConfig(apiName: "followees", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": UserService.pageCount,
            "id": userId
        ]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array : [AnyObject]? = response.result?.objectForKey("followees") as? [AnyObject]
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                if array != nil {
                    var data = [UTUserInfo]()
                    for obj in array! {
                        data.append(UserService.processUserInfoResult(obj))
                    }
                    self.delegate?.didGetUserFollowings?(true, page: page, hasNext: hasNext, data: data, error: nil)
                } else {
                    self.delegate?.didGetUserFollowings?(false, page: page, hasNext: false, data: nil, error: "Failed to get user followers")
                }
                
            } else {
                self.delegate?.didGetUserFollowings?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
            
        })
    }
    
    func updateUserInfo(information: [String: AnyObject]) {
        let config = UTAPIConfig(apiName: "information.update", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["information": information]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didUpdateUserInformation?(true, information: information, error: nil)
            } else {
                self.delegate?.didUpdateUserInformation?(false, information: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func followUser(userId: String) {
        let config = UTAPIConfig(apiName: "follow", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["targetId": userId]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didFollowedUser?(true, userId: userId, error: nil)
            } else {
                self.delegate?.didFollowedUser?(false, userId: userId, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func unfollowUser(userId: String) {
        let config = UTAPIConfig(apiName: "unfollow", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["targetId": userId]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didUnfollowedUser?(true, userId: userId, error: nil)
            } else {
                self.delegate?.didUnfollowedUser?(false, userId: userId, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    class func processUserInfoResult(obj: AnyObject?) -> UTUserInfo {
        if (obj as? [String: AnyObject]) == nil {
            return UTUserInfo(userId: "", nickname: "", avatar: "", desc: "", sex: .Female, city: "", birthday: 619714800.0, followed_by_user: false, followerCount: 0, followingCount: 0, credit: 0, topicCount: 0, crown: 0)
        } else {
            let userId : String = obj!.objectForKey("userId") as? String ?? ""
            let nickname : String = obj!.objectForKey("nickname") as? String ?? ""
            var avatar : String = obj!.objectForKey("avatar") as? String ?? ""
            if !avatar.isEmpty {
                avatar += "?imageView2/0/format/webp"
            }
            let desc : String = obj!.objectForKey("desc") as? String ?? ""
            let sex : UTSexCategory = UTSexCategory(rawValue: obj!.objectForKey("sex") as? String ?? "f") ?? UTSexCategory.Female
            let city : String = obj!.objectForKey("city") as? String ?? ""
            let birthday : Double = obj!.objectForKey("birthday") as? Double ?? 619714800.0
            let followed_by_user : Bool = obj!.objectForKey("followed_by_user") as? Bool ?? false
            let followerCount : Int = obj!.objectForKey("followed_by_count") as? Int ?? 0
            let followingCount : Int = obj!.objectForKey("following_count") as? Int ?? 0
            let credit : Int = obj!.objectForKey("credit") as? Int ?? 0
            let topicCount : Int = obj!.objectForKey("topic_count") as? Int ?? 0
            let crown : Int = obj!.objectForKey("crown") as? Int ?? 0
            return UTUserInfo(userId: userId, nickname: nickname, avatar: avatar, desc: desc, sex: sex, city: city, birthday: birthday, followed_by_user: followed_by_user, followerCount: followerCount, followingCount: followingCount, credit: credit, topicCount: topicCount, crown: crown)
        }
        
        
    }
    
    func processUserTrainningTrackResults(array: [AnyObject]) -> [UTUserTrainningTrack] {
        var tracks : [UTUserTrainningTrack] = [UTUserTrainningTrack]()
        
        for obj in array {
            tracks.append(processUserTrainningTrackResult(obj))
        }
        return tracks
    }
    
    func processUserTrainningTrackResult(obj: AnyObject) -> UTUserTrainningTrack {
        let id : String = obj.objectForKey("id") as? String ?? ""
        let trainningId : String = obj.objectForKey("trainningId") as? String ?? ""
        let trainningName : String = obj.objectForKey("trainningName") as? String ?? ""
        let complete : Int = obj.objectForKey("complete") as? Int ?? 0
        let duration : Double = obj.objectForKey("duration") as? Double ?? 0
        let credit : Int = obj.objectForKey("credit") as? Int ?? 0
        let createdAt : Double = obj.objectForKey("createdAt") as? Double ?? 1443137853.0
        
        return UTUserTrainningTrack(id: id, trainningId: trainningId, trainningName: trainningName, complete: complete, duration: duration, credit: credit, createdAt: createdAt)
    }
}
