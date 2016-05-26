//
//  TrainningService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/2/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

@objc protocol TrainningServiceDelegate {
    optional func didGetAllTrainnings(success: Bool, page: Int, hasNext: Bool, data: [UTTrainning]?, error: String?)
    optional func didGetRecommendTrainnings(success: Bool, data: [UTTrainning]?, error: String?)
    optional func didGetUserTrainningsForStatus(status: String, success: Bool, data: [UTTrainning]?, error: String?)
    optional func didGetHomeTrainnings(success: Bool, data: [String: [UTTrainning]]?, error: String?)
    optional func didGetUserTrainningSummary(success: Bool, data: UTUserTrainningSummary?, error: String?)
    optional func didGetUnreadMessageCount(success: Bool, count: Int, categoryId: String, teacher: UTUserInfo?, error: String?)
    optional func didGetMoreTrainning(success: Bool, orgnizations: [UTOrgnization]?, categories: [UTTrainningCategory]?, error: String?)
    
    optional func didGetCategoryTrainnings(success: Bool, page: Int, hasNext: Bool, data: [UTTrainning]?, error: String?)
    optional func didGetOrgnizationTrainnings(success: Bool, page: Int, hasNext: Bool, data: [UTTrainning]?, error: String?)
    optional func didGetOrgnizationDetail(success: Bool, data: UTOrgnization?, error: String?)
    
}

class TrainningService: NSObject {
    private weak var delegate: TrainningServiceDelegate?
    static let pageCount: Int = 10
    
    init(delegate: TrainningServiceDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    func getUnreadMessageCount() {
        if UTRuntime.currentUser() == nil {
            return
        }
        let config = UTAPIConfig(apiName: "reply.unread", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                var teacher : UTUserInfo? = nil
                if let obj = response.result?.objectForKey("teacher") {
                    teacher = UserService.processUserInfoResult(obj)
                }
                self.delegate?.didGetUnreadMessageCount?(true, count: response.result?.objectForKey("count") as? Int ?? 0, categoryId: response.result?.objectForKey("id") as? String ?? "", teacher: teacher, error: nil)
            } else {
                self.delegate?.didGetUnreadMessageCount?(false, count: 0, categoryId: "", teacher: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
        
    }
    
    func getUserTrainnings(status: UTTrainningStatus) {
        if UTRuntime.currentUser() == nil {
            return
        }
        let config = UTAPIConfig(apiName: "trainnings", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["status": status.rawValue]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array = response.result as? [AnyObject]
                if array != nil {
                    self.delegate?.didGetUserTrainningsForStatus?(status.rawValue, success: true, data: TrainningService.processTrainningResult(array!), error: nil)
                    
                } else {
                    self.delegate?.didGetUserTrainningsForStatus?(status.rawValue, success: false, data: nil, error: response.error?.userInfo["error"] as? String)
                }
            } else {

                self.delegate?.didGetUserTrainningsForStatus?(status.rawValue, success: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
        
    }
    
    func getRecommendTrainnings() {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: "recommends", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array = response.result?.objectForKey("data") as? [AnyObject]
                if array != nil {
                    self.delegate?.didGetRecommendTrainnings?(true, data: TrainningService.processTrainningResult(array!), error: nil)
                    
                } else {
                    self.delegate?.didGetRecommendTrainnings?(false, data: nil, error: "Failed to get trainnings")
                }
            } else {
                self.delegate?.didGetRecommendTrainnings?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func getAllTrainnings(page: Int) {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: "all", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": TrainningService.pageCount
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                var array = response.result?.objectForKey("data") as? [AnyObject]
                let hasNext = response.result?.objectForKey("hasNext") as? Bool ?? false
                if array != nil {
                    self.delegate?.didGetAllTrainnings?(true, page: page, hasNext: hasNext, data: TrainningService.processTrainningResult(array!), error: nil)
                    array?.removeAll(keepCapacity: false)
                    array = nil
                } else {
                    self.delegate?.didGetAllTrainnings?(false, page: page, hasNext: false, data: nil, error: "Failed to get trainnings")
                }
            } else {
                self.delegate?.didGetAllTrainnings?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func getMoreTrainnings() {
        let config = UTAPIConfig(apiName: "more", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.startRequestWithMethod(.GET) { (response: UTAPIResponse) in
            if response.success {
                var orgnizations = [UTOrgnization]()
                var categories = [UTTrainningCategory]()
                
                for obj in response.result?.objectForKey("orgnizations") as? [AnyObject] ?? [] {
                    orgnizations.append(TrainningService.processOrgnizationResult(obj))
                }
                
                for obj in response.result?.objectForKey("categories") as? [AnyObject] ?? [] {
                    categories.append(TrainningService.processTrainningCategoryResult(obj))
                }
                
                self.delegate?.didGetMoreTrainning?(true, orgnizations: orgnizations, categories: categories, error: nil)
            } else {
                self.delegate?.didGetMoreTrainning?(false, orgnizations: nil, categories: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    
    func getCategoryTrainnings(category: String, page: Int) {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: "category.list", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": TrainningService.pageCount,
            "id": category
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                var array = response.result?.objectForKey("data") as? [AnyObject]
                let hasNext = response.result?.objectForKey("hasNext") as? Bool ?? false
                if array != nil {
                    self.delegate?.didGetCategoryTrainnings?(true, page: page, hasNext: hasNext, data: TrainningService.processTrainningResult(array!), error: nil)
                    array?.removeAll(keepCapacity: false)
                    array = nil
                } else {
                    self.delegate?.didGetCategoryTrainnings?(false, page: page, hasNext: false, data: nil, error: "Failed to get trainnings")
                }
            } else {
                self.delegate?.didGetCategoryTrainnings?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func getOrgnizationTrainnings(orgId: String, page: Int) {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: "orgnization.list", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": TrainningService.pageCount,
            "id": orgId
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                var array = response.result?.objectForKey("data") as? [AnyObject]
                let hasNext = response.result?.objectForKey("hasNext") as? Bool ?? false
                if array != nil {
                    self.delegate?.didGetOrgnizationTrainnings?(true, page: page, hasNext: hasNext, data: TrainningService.processTrainningResult(array!), error: nil)
                    array?.removeAll(keepCapacity: false)
                    array = nil
                } else {
                    self.delegate?.didGetOrgnizationTrainnings?(false, page: page, hasNext: false, data: nil, error: "Failed to get trainnings")
                }
            } else {
                self.delegate?.didGetOrgnizationTrainnings?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    func getOrgnizationDetail(orgId: String) {
        let needAuth : Bool = UTRuntime.currentUser() != nil
        let config = UTAPIConfig(apiName: "orgnization", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": orgId
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didGetOrgnizationDetail?(true, data: TrainningService.processOrgnizationResult(response.result), error: nil)
            } else {
                self.delegate?.didGetOrgnizationDetail?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    
    func getUserTrainningSummary() {
        if UTRuntime.currentUser() == nil {
            return
        }
        let config = UTAPIConfig(apiName: "trainning.summary", apiNamespace: "user", apiVersion: "101", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                if response.result != nil {
                    let obj : AnyObject = response.result!
                    
                    self.delegate?.didGetUserTrainningSummary?(true, data: TrainningService.processTrainningSummaryResult(obj), error: nil)
                    
                } else {
                    self.delegate?.didGetUserTrainningSummary?(false, data: nil, error: "Failed to get user summary info")
                }
            } else {
                self.delegate?.didGetUserTrainningSummary?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    class func processTrainningRes(obj: AnyObject) -> UTTrainning {
        let id : String = obj.objectForKey("id") as? String ?? ""
        let name : String = obj.objectForKey("name") as? String ?? ""
        let desc : String = obj.objectForKey("desc") as? String ?? ""
        var imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
        if !imageUrl.isEmpty {
            imageUrl += "?imageView2/0/format/webp"
        }
        var thumbnail : String = obj.objectForKey("thumbnail") as? String ?? ""
        if !thumbnail.isEmpty {
            thumbnail += "?imageView2/0/format/webp"
        }
        let type : UTTrainningType = UTTrainningType(rawValue: obj.objectForKey("type") as? String ?? "plan") ?? .Plan
        let difficulty : UTDifficulty = UTDifficulty(rawValue: obj.objectForKey("difficulty") as? Int ?? 0) ?? .Zero
        let joined : Bool = obj.objectForKey("joined") as? Bool ?? false
        let total : Int = obj.objectForKey("total") as? Int ?? 0
        let complete : Int = obj.objectForKey("complete") as? Int ?? 0
        let credit : Int = obj.objectForKey("credit") as? Int ?? 0
        let attendCount : Int = obj.objectForKey("attendCount") as? Int ?? 0
        let previewVideo : String = obj.objectForKey("previewVideo") as? String ?? ""
        let workouts : [String] = obj.objectForKey("workouts") as? [String] ?? []
        let duration : Int = obj.objectForKey("duration") as? Int ?? 0
        let tags : [UTTrainningTag] = TrainningService.processTrainningTagsResult(obj.objectForKey("tags") as? [AnyObject] ?? [])
        let newImageUrls : [String: String] = obj.objectForKey("newImageUrls") as? [String: String] ?? [String: String]()
        let label : UTTrainningLabel = UTTrainningLabel(rawValue: obj.objectForKey("label") as? String ?? "none") ?? .None
        let attentions = TrainningService.processAttetionsResult(obj.objectForKey("attentions") as? [AnyObject] ?? [])
        let price : Int = obj.objectForKey("price") as? Int ?? 0
        
        return UTTrainning(id: id, name: name, desc: desc, imageUrl: imageUrl, thumbnail: thumbnail, type: type, difficulty: difficulty, joined: joined, total: total, complete: complete, credit: credit, attendCount: attendCount, previewVideo: previewVideo, workouts: workouts, duration: duration, tags: tags, newImageUrls: newImageUrls, label: label, attentions: attentions, price: price)
    }
    
    class func processTrainningResult(array: [AnyObject]) -> [UTTrainning] {
        var trainnings = [UTTrainning]()
        
        for obj in array {
            trainnings.append(TrainningService.processTrainningRes(obj))
        }
        
        return trainnings
    }
    
    class func processTrainningTagsResult(array: [AnyObject]) -> [UTTrainningTag] {
        var tags : [UTTrainningTag] = [UTTrainningTag]()
        
        for obj in array {
            let name : String = obj.objectForKey("name") as? String ?? ""
            let priority : Int = obj.objectForKey("priority") as? Int ?? 1
            
            tags.append(UTTrainningTag(name: name, priority: priority))
        }
        return tags
    }
    
    class func processAttetionsResult(array: [AnyObject]) -> [UTTrainningAttention] {
        var attentions = [UTTrainningAttention]()
        
        for obj in array {
            let name : String = obj.objectForKey("name") as? String ?? ""
            let type : UTTrainningAttentionType = UTTrainningAttentionType(rawValue: obj.objectForKey("type") as? String ?? "none") ?? .None
            let detail : String = obj.objectForKey("value") as? String ?? ""
            attentions.append(UTTrainningAttention(name: name, type: type, detail: detail))
        }
        
        return attentions
    }
    
    class func processOrgnizationResult(obj: AnyObject!) -> UTOrgnization {
        if obj == nil {
            return UTOrgnization(id: "", name: "", desc: "", logo: "", imageUrl: "", userId: "", new: "", show: "", teachers: [], type: .None, count: 0, followed_by_user: false)
        }
        let id : String = obj.objectForKey("objectId") as? String ?? ""
        let name : String = obj.objectForKey("name") as? String ?? ""
        let desc : String = obj.objectForKey("desc") as? String ?? ""
        let logo : String = obj.objectForKey("logo") as? String ?? ""
        let imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
        let userId : String = obj.objectForKey("userId") as? String ?? ""
        let newTrainning : String = obj.objectForKey("new") as? String ?? ""
        let showingText : String = obj.objectForKey("show") as? String ?? ""
        let followed_by_user = obj.objectForKey("followed_by_user") as? Bool ?? false
        
        var teachers : [UTTeacher] = [UTTeacher]()
        for res in obj.objectForKey("teachers") as? [AnyObject] ?? [] {
            teachers.append(TrainningDetailService.processTeacherResult(res))
        }        
        let type : UTOrgnizationType = UTOrgnizationType(rawValue: obj.objectForKey("type") as? String ?? "none") ?? .None
        let trainningCount : Int = obj.objectForKey("trainningCount") as? Int ?? 0
        
        return UTOrgnization(id: id, name: name, desc: desc, logo: logo, imageUrl: imageUrl, userId: userId, new: newTrainning, show: showingText, teachers: teachers, type: type, count: trainningCount, followed_by_user: followed_by_user)
    }
    
    class func processTrainningCategoryResult(obj: AnyObject) -> UTTrainningCategory {
        let id : String = obj.objectForKey("objectId") as? String ?? ""
        let name : String = obj.objectForKey("name") as? String ?? ""
        let desc : String = obj.objectForKey("desc") as? String ?? ""
        let imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
        let trainningCount : Int = obj.objectForKey("trainningCount") as? Int ?? 0
        
        return UTTrainningCategory(id: id, name: name, desc: desc, imageUrl: imageUrl, count: trainningCount)
    }
    
    class func processTrainningSummaryResult(obj: AnyObject) -> UTUserTrainningSummary {
        let todayCount : Int = obj.objectForKey("todayCount") as? Int ?? 0
        let count : Int = obj.objectForKey("count") as? Int ?? 0
        let time : Double = obj.objectForKey("time") as? Double ?? 0
        let level : Int = obj.objectForKey("level") as? Int ?? 0
        let progress : Double = obj.objectForKey("progress") as? Double ?? 0
        
        let summary = UTUserTrainningSummary(todayCount: todayCount, count: count, time: time, level: level, progress: progress)
        if let coupon = obj.objectForKey("coupon") {
            summary.coupon = CouponService.processCouponResult(coupon)
        }
        
        return summary
    }
    
    
}