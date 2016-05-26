//
//  CircleService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/9/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

@objc public protocol CircleServiceDelegate {
    optional func didGetCircleDetail(success: Bool, hasNext: Bool, data: UTCircleDetail?, error: String?)
    optional func didGetAllCircles(success: Bool, data: [UTCircle]?, error: String?)
    optional func didJoinCircles(success: Bool, error: String?)
    optional func didJoinCircle(success: Bool, error: String?)
    optional func didQuitCircle(success: Bool, error: String?)
    optional func didGetCircleTypes(success: Bool, data: [UTCircleType]?, error: String?)
    optional func didGetCategoryCircles(success: Bool, category: String, data: [UTCircle]?, error: String?)
    optional func didGetUnreadCount(success: Bool, count: Int, error: String?)
    optional func didGetCircleMessages(success: Bool, page: Int, hasNext: Bool, data: [UTCircleMessage]?, error: String?)
    optional func didReadMessage(success: Bool, messageId: String, error: String?)
    optional func didGetCircleTopics(success: Bool, page: Int, hasNext: Bool, data: [UTTopic]?, error: String?)
    optional func didGetMessageCategories(success: Bool, data: [UTMessageCategory]?, error: String?)
    optional func didGetCategoryMessages(success: Bool, category: String, page: Int, hasNext: Bool, data: [UTCircleMessage]?, error: String?)
    optional func didGetActivityMessages(success: Bool, page: Int, hasNext: Bool, data: [UTCircleMessage]?, error: String?)
    optional func didReadCategoryMessages(success: Bool, category: String, error: String?)
    optional func didReadActivityMessages(success: Bool, error: String?)
    
}

public class CircleService : NSObject {
    private weak var delegate: CircleServiceDelegate?
    static let pageCount : Int = 10
    
    public init(delegate: CircleServiceDelegate) {
        super.init()
        self.delegate = delegate
    }
    
//    func readMessage(id: String) {
//        
//        let config = UTAPIConfig(apiName: "message.read", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: true)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["id": id]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                self.delegate?.didReadMessage?(true, messageId: id, error: nil)
//            } else {
//                self.delegate?.didReadMessage?(false, messageId: id, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
    
    public func getUnreadCount() {
        let config = UTAPIConfig(apiName: "circle.unread", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let count = response.result?.objectForKey("count") as? Int ?? 0
                self.delegate?.didGetUnreadCount?(true, count: count, error: nil)
            } else {
                self.delegate?.didGetUnreadCount?(false, count: 0, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getMessageCategories() {
        let config = UTAPIConfig(apiName: "message.categories", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                if let array = response.result as? [AnyObject] {
                    self.delegate?.didGetMessageCategories?(true, data: self.processMessageCategoruResult(array), error: nil)
                } else {
                    self.delegate?.didGetMessageCategories?(false, data: nil, error: "获取数据失败")
                }
            } else {
                self.delegate?.didGetMessageCategories?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public func getCategoryMessages(categoryId: String, page: Int) {
        let config = UTAPIConfig(apiName: "category.messages", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": CircleService.pageCount,
            "id": categoryId
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                
                if let array = response.result?.objectForKey("data") as? [AnyObject] {
                    self.delegate?.didGetCategoryMessages?(true, category: categoryId, page: page, hasNext: hasNext, data: self.processCircleMessageResult(array), error: nil)
                } else {
                    self.delegate?.didGetCategoryMessages?(false, category: categoryId, page: page, hasNext: false, data: nil, error: "获取数据失败")
                }
            } else {
                self.delegate?.didGetCategoryMessages?(false, category: categoryId, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public func getActivityMessages(page: Int) {
        let config = UTAPIConfig(apiName: "activity.messages", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": CircleService.pageCount
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                
                if let array = response.result?.objectForKey("data") as? [AnyObject] {
                    self.delegate?.didGetActivityMessages?(true, page: page, hasNext: hasNext, data: self.processCircleMessageResult(array), error: nil)
                } else {
                    self.delegate?.didGetActivityMessages?(false, page: page, hasNext: false, data: nil, error: "获取数据失败")
                }
            } else {
                self.delegate?.didGetActivityMessages?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public func readCategoryMessages(categoryId: String) {
        let config = UTAPIConfig(apiName: "category.read", apiNamespace: "circle", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["category": categoryId]
        request.startRequestWithMethod(.POST, callback: { (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didReadCategoryMessages?(true, category: categoryId, error: nil)
            } else {
                self.delegate?.didReadCategoryMessages?(false, category: categoryId, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func readActivityMessages() {
        let config = UTAPIConfig(apiName: "activity.read", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)

        request.startRequestWithMethod(.POST, callback: { (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didReadActivityMessages?(true, error: nil)
            } else {
                self.delegate?.didReadActivityMessages?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
//    func getCircleMessages(page: Int) {
//        let config = UTAPIConfig(apiName: "circle.messages", apiNamespace: "user", apiVersion: "2", apiIsNeedAuth: true)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = [
//            "index": page,
//            "count": CircleService.pageCount
//        ]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let array : [AnyObject]? = response.result?.objectForKey("data") as? [AnyObject]
//                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
//                if array != nil {
//                    self.delegate?.didGetCircleMessages?(true, page: page, hasNext: hasNext, data: self.processCircleMessageResult(array!), error: nil)
//                    
//                } else {
//                    self.delegate?.didGetCircleMessages?(false, page: page, hasNext: false, data: nil, error: "Failed to get messages")
//                }
//            } else {
//                self.delegate?.didGetCircleMessages?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
    
//    func getCircleTypes() {
//        let config = UTAPIConfig(apiName: "categories", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: false)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.startRequestWithMethod(.GET, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let array : [AnyObject]? = response.result as? [AnyObject]
//                if array != nil {
//                    self.delegate?.didGetCircleTypes?(true, data: self.processCategoryResult(array!), error: nil)
//                    
//                } else {
//                    self.delegate?.didGetCircleTypes?(false, data: nil, error: "Failed to get circle categories")
//                }
//            } else {
//                self.delegate?.didGetCircleTypes?(false, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
//    
//    func getCategoryCircles(categoryId: String) {
//        let config = UTAPIConfig(apiName: "category.circles", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: false)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["cid": categoryId]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let array : [AnyObject]? = response.result as? [AnyObject]
//                if array != nil {
//                    self.delegate?.didGetCategoryCircles?(true, category: categoryId, data: CircleService.processCirclesResult(array!), error: nil)
//                    
//                } else {
//                    self.delegate?.didGetCategoryCircles?(false, category: categoryId, data: nil, error: "Failed to get circles")
//                }
//            } else {
//                self.delegate?.didGetCategoryCircles?(false, category: categoryId, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//        
//    }
//    
//    
//    func getAllCircles() {
//        let config = UTAPIConfig(apiName: "all", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: false)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let array : [AnyObject]? = response.result as? [AnyObject]
//                if array != nil {
//                    self.delegate?.didGetAllCircles?(true, data: CircleService.processCirclesResult(array!), error: nil)
//                    
//                } else {
//                    self.delegate?.didGetAllCircles?(false, data: nil, error: "Failed to get recommend circles")
//                }
//                
//            } else {
//                self.delegate?.didGetAllCircles?(false, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
//    
//    func joinCircles(ids: [String]) {
//        let config = UTAPIConfig(apiName: "circles.join", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: true)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["ids": ids.joinWithSeparator(",")]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                self.delegate?.didJoinCircles?(true, error: nil)
//            } else {
//                self.delegate?.didJoinCircles?(false, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
//    
//    
//    func joinCircle(id: String) {
//        
//        let config = UTAPIConfig(apiName: "like", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: true)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["id": id]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                self.delegate?.didJoinCircle?(true, error: nil)
//            } else {
//                self.delegate?.didJoinCircle?(false, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//        
//    }
//    
//    func quitCircle(id: String) {
//        let config = UTAPIConfig(apiName: "dislike", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: true)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["id": id]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                self.delegate?.didQuitCircle?(true, error: nil)
//            } else {
//                self.delegate?.didQuitCircle?(false, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//        
//    }
//    
//    func getCircleDetail(id: String) {
//        let needAuth : Bool = UTRuntime.currentUser() != nil
//        let config = UTAPIConfig(apiName: id, apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: needAuth)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = [
//            "index": 0,
//            "count": CircleService.pageCount
//        ]
//        
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let hasNext: Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
//                self.delegate?.didGetCircleDetail?(true, hasNext: hasNext, data: self.processCircleDetailResult(response.result!), error: nil)
//            } else {
//                self.delegate?.didGetCircleDetail?(false, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//        
//    }
//    
//    func getCircleTopics(id: String, page: Int) {
//        let needAuth : Bool = UTRuntime.currentUser() != nil
//        let config = UTAPIConfig(apiName: "topics", apiNamespace: "circle", apiVersion: "1", apiIsNeedAuth: needAuth)
//        let request = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = [
//            "index": page,
//            "count": CircleService.pageCount,
//            "id": id
//        ]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                let hasNext: Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
//                let arrayData = response.result?.objectForKey("data") as? [AnyObject]
//                if arrayData == nil {
//                    self.delegate?.didGetCircleTopics?(false, page: page, hasNext: false, data: nil, error: "Failed to get circle topics")
//                } else {
//                    self.delegate?.didGetCircleTopics?(true, page: page, hasNext: hasNext, data: FeedsService.processTopicResults(arrayData!), error: nil)
//                }
//                
//            } else {
//                self.delegate?.didGetCircleTopics?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
    
    
    
    public func processCircleDetailResult(obj: AnyObject) -> UTCircleDetail {
        let id : String = obj.objectForKey("id") as? String ?? ""
        let name : String = obj.objectForKey("name") as? String ?? ""
        var imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
        if !imageUrl.isEmpty {
            imageUrl += "?imageView2/0/format/webp"
        }
        var thumbnail : String = obj.objectForKey("thumbnail") as? String ?? ""
        if !thumbnail.isEmpty {
            thumbnail += "?imageView2/0/format/webp"
        }
        
        let desc : String = obj.objectForKey("desc") as? String ?? ""
        let userCount : Int = obj.objectForKey("userCount") as? Int ?? 0
        let topicCount : Int = obj.objectForKey("topicCount") as? Int ?? 0
        let joined : Bool = obj.objectForKey("joined") as? Bool ?? false
        
        let topics : [UTTopic] = FeedsService.processTopicResults(obj.objectForKey("topics") as? [AnyObject] ?? [])
        
        return UTCircleDetail(circle: UTCircle(id: id, name: name, imageUrl: imageUrl, thumbnail: thumbnail, desc: desc, userCount: userCount, topicCount: topicCount, joined: joined), topics: topics)
    }
    
    public class func processCirclesResult(array: [AnyObject]) -> [UTCircle] {
        var circles = [UTCircle]()
        
        for obj in array {
            let id : String = obj.objectForKey("id") as? String ?? ""
            let name : String = obj.objectForKey("name") as? String ?? ""
            var imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
            if !imageUrl.isEmpty {
                imageUrl += "?imageView2/0/format/webp"
            }
            
            var thumbnail : String = obj.objectForKey("thumbnail") as? String ?? ""
            if !thumbnail.isEmpty {
                thumbnail += "?imageView2/0/format/webp"
            }
            let desc : String = obj.objectForKey("desc") as? String ?? ""
            let userCount : Int = obj.objectForKey("userCount") as? Int ?? 0
            let topicCount : Int = obj.objectForKey("topicCount") as? Int ?? 0
            let joined : Bool = obj.objectForKey("joined") as? Bool ?? false
            circles.append(UTCircle(id: id, name: name, imageUrl: imageUrl, thumbnail: thumbnail, desc: desc, userCount: userCount, topicCount: topicCount, joined: joined))
        }
        
        return circles
    }
    
    public func processCategoryResult(array: [AnyObject]) -> [UTCircleType] {
        var categories = [UTCircleType]()
        
        for obj in array {
            let categoryId: String = obj.objectForKey("id") as? String ?? ""
            let categoryName : String = obj.objectForKey("name") as? String ?? ""
            
            categories.append(UTCircleType(categoryId: categoryId, categoryName: categoryName))
        }
        
        return categories
    }
    
    public func processCircleMessageResult(array: [AnyObject]) -> [UTCircleMessage] {
        var messages = [UTCircleMessage]()
        
        for obj in array {
            let id : String = obj.objectForKey("id") as? String ?? ""
            let sender : UTUserInfo = UserService.processUserInfoResult(obj.objectForKey("sender"))
            let messageId : String = obj.objectForKey("messageId") as? String ?? ""
            let name: String = obj.objectForKey("name") as? String ?? ""
            let content: String = obj.objectForKey("content") as? String ?? ""
            let type : UTCircleMessageType = UTCircleMessageType(rawValue: obj.objectForKey("type") as? String ?? "follow") ?? .Follow
            let categoryId : String = obj.objectForKey("category") as? String ?? ""
            let status : UTMessageStatus = UTMessageStatus(rawValue: obj.objectForKey("status") as? String ?? "read") ?? .Read
            let createdAt : Double = obj.objectForKey("createdAt") as? Double ?? 1445997461.0
            let imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
            
            messages.append(UTCircleMessage(id: id, sender: sender, messageId: messageId, name: name, content: content, type: type, categoryId: categoryId, status: status, createdAt: createdAt, imageUrl: imageUrl))
        }
        
        return messages
    }
    
    public func processMessageCategoruResult(array: [AnyObject]) -> [UTMessageCategory] {
        var categories = [UTMessageCategory]()
        
        for obj in array {
            let id : String = obj.objectForKey("id") as? String ?? ""
            let name : String = obj.objectForKey("name") as? String ?? ""
            let unreadCount : Int = obj.objectForKey("count") as? Int ?? 0
            let slug : String = obj.objectForKey("slug") as? String ?? ""
            categories.append(UTMessageCategory(id: id, name: name, count: unreadCount, slug: slug))
            
        }
        return categories
    }


}