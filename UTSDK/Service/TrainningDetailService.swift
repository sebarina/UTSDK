//
//  TrainningDetailService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/24/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

@objc protocol TrainningDetailServiceDelegate {
    optional func didGetTrainningDetail(success: Bool, data: UTTrainningDetail?, error: String?)
    optional func didJoinTrainning(success: Bool, error: String?)
    optional func didBuyTrainning(success: Bool, error: String?)
    optional func didCompleteTrainning(success: Bool, complete: Int, crown: Int, error: String?)
    optional func didQuitTrainning(success: Bool, error: String?)
//    optional func didGetTrainningTracks(success: Bool, hasNext: Bool, page: Int, data: [UTTrainningTrack]?, error: String?)
    optional func didGetTrainningTeacher(success: Bool, data: UTTeacher?, error: String?)
}

class TrainningDetailService : NSObject {
    
    private weak var delegate : TrainningDetailServiceDelegate?
    static let pageCount : Int = 20
    
    init(delegate: TrainningDetailServiceDelegate) {
        self.delegate = delegate
        
        super.init()
        
    }
    
    func getTrainningDetail(id: String) {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: id, apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didGetTrainningDetail?(true, data: self.processTrainningDetailResult(response.result!), error: nil)
            } else {
                self.delegate?.didGetTrainningDetail?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
        
    }
    
//    func getTrainningTracks(trainningId: String, page: Int) {
//        let config = UTAPIConfig(apiName: "tracks", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: false)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = [
//            "id": trainningId,
//            "index": page,
//            "count": TrainningDetailService.pageCount
//        ]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
//                var array = response.result?.objectForKey("data") as? [AnyObject]
//                if array != nil {
//                    self.delegate?.didGetTrainningTracks?(true, hasNext: hasNext, page: page, data: self.processTrainningTrackResults(array!), error: nil)
//                    array?.removeAll(keepCapacity: false)
//                    array = nil
//                } else {
//                    self.delegate?.didGetTrainningTracks?(false, hasNext: false, page: page, data: nil, error: "Failed to get trainning tracks")
//                }
//                
//            } else {
//                self.delegate?.didGetTrainningTracks?(false, hasNext: false, page: page, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
    
    func joinTrainning(id: String) {
        let config = UTAPIConfig(apiName: "join", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": id]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didJoinTrainning?(true, error: nil)
            } else {
                self.delegate?.didJoinTrainning?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func buyTrainning(id: String) {
        let config = UTAPIConfig(apiName: "buy", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": id]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didBuyTrainning?(true, error: nil)
            } else {
                self.delegate?.didBuyTrainning?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func quitTrainning(id: String) {
        let config = UTAPIConfig(apiName: "quit", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": id]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didQuitTrainning?(true, error: nil)
            } else {
                self.delegate?.didQuitTrainning?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func completeTrainning(id: String, day: Int, duration: Double) {
        let config = UTAPIConfig(apiName: "complete", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": id, "day": day, "duration": Int(duration)]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didCompleteTrainning?(true, complete: day, crown: response.result?.objectForKey("crown") as? Int ?? 0, error: nil)
            } else {
                self.delegate?.didCompleteTrainning?(false, complete: day, crown: 0, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func getTrainningTeacher(trainningId: String) {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: "teacher", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": trainningId
        ]
        request.startRequestWithMethod(.POST) { (result: UTAPIResponse) in
            if result.success {
                self.delegate?.didGetTrainningTeacher?(true, data: TrainningDetailService.processTeacherResult(result.result), error: nil)
            } else {
                self.delegate?.didGetTrainningTeacher?(false, data: nil, error: result.error?.userInfo["error"] as? String)
            }
        }
    }
    
    func processTrainningDetailResult(obj: AnyObject) -> UTTrainningDetail {
        let trainning : UTTrainning = TrainningService.processTrainningRes(obj)
        
        var array : [AnyObject] = obj.objectForKey("workouts") as? [AnyObject] ?? []
        var workouts : [UTWorkout] = [UTWorkout]()
        for temp in array {
            workouts.append(processWorkoutResult(temp))
        }
        array.removeAll(keepCapacity: false)
    
        let teacher : UTTeacher = TrainningDetailService.processTeacherResult(obj.objectForKey("teacher"))
        
        let reviews : [UTTrainningComment] = TrainningCommentService.processCommentResults(obj.objectForKey("reviews") as? [AnyObject] ?? [])
        
        let orgnization : UTOrgnization = TrainningService.processOrgnizationResult(obj.objectForKey("supplier"))
        
        let unlocked : Bool = obj.objectForKey("unlocked") as? Bool ?? true
        
        return UTTrainningDetail(trainning: trainning, workouts: workouts, teacher: teacher, reviews: reviews, orgnization: orgnization, unlocked: unlocked)
    }
    
    func processWorkoutResult(obj: AnyObject) -> UTWorkout {
        let id : String = obj.objectForKey("id") as? String ?? ""
        let name : String = obj.objectForKey("name") as? String ?? ""
        let count : Int = obj.objectForKey("count") as? Int ?? 0
        let steps : [String] = obj.objectForKey("steps") as? [String] ?? []
        let duration : Int = obj.objectForKey("duration") as? Int ?? 0
        let credit : Int = obj.objectForKey("credit") as? Int ?? 0
        let videoUrl : String = obj.objectForKey("videoUrl") as? String ?? ""
        return UTWorkout(id: id, name: name, count: count, steps: steps, duration: duration, credit: credit, videoUrl: videoUrl)
    }
    
    func processTrainningTrackResults(array: [AnyObject]) -> [UTTrainningTrack] {
        var tracks : [UTTrainningTrack] = [UTTrainningTrack]()
        for obj in array {
            let id : String = obj.objectForKey("id") as? String ?? ""
            let user : UTUserInfo = UserService.processUserInfoResult(obj.objectForKey("user"))
            let createdAt : Double = obj.objectForKey("createdAt") as? Double ?? 10000
            let complete : Int = obj.objectForKey("complete") as? Int ?? 0
            let trainningId : String = obj.objectForKey("trainningId") as? String ?? ""
            let trainningName : String = obj.objectForKey("trainningName") as? String ?? ""
            let duration : Double = obj.objectForKey("duration") as? Double ?? 0
            let credit : Int = obj.objectForKey("credit") as? Int ?? 0
            tracks.append(UTTrainningTrack(id: id, user: user, createdAt: createdAt, complete: complete, credit: credit, duration: duration, trainningId: trainningId, trainningName: trainningName))
        }
        
        return tracks
    }
    
    class func processTeacherResult(obj: AnyObject?) -> UTTeacher {
        if obj == nil {
            return UTTeacher(id: "", name: "老师名", desc: "暂无介绍", detail: "", avatar: "", images: [], videoUrl: "", followed_by_user: false)
        }
        let id : String = obj?.objectForKey("userId") as? String ?? ""
        let name : String = obj?.objectForKey("name") as? String ?? ""
        let desc : String = obj?.objectForKey("desc") as? String ?? ""
        let detail : String = obj?.objectForKey("detail") as? String ?? ""
        let avatar : String = obj?.objectForKey("avatar") as? String ?? ""
        let images : [String] = obj?.objectForKey("images") as? [String] ?? []
        let videoUrl : String = obj?.objectForKey("videoUrl") as? String ?? ""
        let followed_by_user : Bool = obj?.objectForKey("followed_by_user") as? Bool ?? false
        
        return UTTeacher(id: id, name: name, desc: desc, detail: detail, avatar: avatar, images: images, videoUrl: videoUrl, followed_by_user: followed_by_user)
    }
    
    
    
}