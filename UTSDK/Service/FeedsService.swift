//
//  FeedsService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 10/20/15.
//  Copyright © 2015 liufan. All rights reserved.
//

import Foundation

@objc public protocol FeedsServiceDelegate {
    optional func didGetHotTopics(success: Bool, page: Int, hasNext: Bool, data: [UTTopic]?, error: String?)
    optional func didGetLatestTopics(success: Bool, page: Int, hasNext: Bool, data: [UTTopic]?, error: String?)
    optional func didGetFollowedTopics(success: Bool, page: Int, hasNext: Bool, data: [UTTopic]?, error: String?)
    optional func didGetUserTopics(success: Bool, page: Int, hasNext: Bool, data: [UTTopic]?, error: String?)
    optional func didGetTopicDetail(success: Bool, hasNext: Bool, data: UTTopicDetail?, error: String?)
    optional func didLikeTopic(success: Bool, topicId: String, error: String?)
    optional func didDislikeTopic(success: Bool, topicId: String, error: String?)
    optional func didCommentTopic(success: Bool, error: String?)
    optional func didPostTopic(success: Bool, topicId: String?, error: String?)
    optional func didGetTopicLikeUsers(success: Bool, page: Int, hasNext: Bool, data: [UTUserInfo]?, error: String?)
    optional func didGetTopic(success: Bool, data: UTTopic?, error: String?)
    optional func didLikeComment(success: Bool, commentId: String, error: String?)
    optional func didDislikeComment(success: Bool, commentId: String, error: String?)
    optional func didGetTopicComment(success: Bool, data: UTTopicComment?, error: String?)
    optional func didReportContent(success: Bool, contentId: String, error: String?)
    optional func didGetTopicComments(success: Bool, page: Int, hasNext: Bool, data: [UTTopicComment]?, error: String?)
    
    optional func didDeleteTopic(success: Bool, topicId: String, error: String?)
    optional func didDeleteTopicComment(success: Bool, commentId: String, topicId: String, error: String?)
}

public class FeedsService : NSObject {
    private weak var delegate : FeedsServiceDelegate?
    static let pageCount : Int = 10
    
    public init(delegate: FeedsServiceDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    public func getHotTopics(page: Int) {
        let needAuth : Bool = UTRuntime.currentUser() == nil ? false: true
        let config = UTAPIConfig(apiName: "hot", apiNamespace: "feeds", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        
        request.requestParams = [
            "index": page,
            "count": FeedsService.pageCount
        ]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                let array = response.result?.objectForKey("feeds") as? [AnyObject]
                if array != nil {
                    self.delegate?.didGetHotTopics?(true, page: page, hasNext: hasNext, data: FeedsService.processTopicResults(array!), error: nil)
                } else {
                    self.delegate?.didGetHotTopics?(false, page: page, hasNext: false, data: nil, error: "Failed to get topics")
                }
            } else {
                self.delegate?.didGetHotTopics?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getLatestTopics(page: Int) {
        let needAuth : Bool = UTRuntime.currentUser() == nil ? false: true
        let config = UTAPIConfig(apiName: "latest", apiNamespace: "feeds", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": FeedsService.pageCount
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                let array = response.result?.objectForKey("feeds") as? [AnyObject]
                if array != nil {
                    self.delegate?.didGetLatestTopics?(true, page: page, hasNext: hasNext,data: FeedsService.processTopicResults(array!), error: nil)
                } else {
                    self.delegate?.didGetLatestTopics?(false, page: page, hasNext: false, data: nil, error: "Failed to get topics")
                }
            } else {
                self.delegate?.didGetLatestTopics?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getFollowedTopics(page: Int) {
        if UTRuntime.currentUser() == nil {
            return
        }
        let config = UTAPIConfig(apiName: "followed", apiNamespace: "feeds", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": FeedsService.pageCount
        ]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                let array = response.result?.objectForKey("feeds") as? [AnyObject]
                if array != nil {
                    self.delegate?.didGetFollowedTopics?(true, page: page, hasNext: hasNext,data: FeedsService.processTopicResults(array!), error: nil)
                } else {
                    self.delegate?.didGetFollowedTopics?(false, page: page, hasNext: false, data: nil, error: "Failed to get topics")
                }
            } else {
                self.delegate?.didGetFollowedTopics?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getUserTopics(page: Int, userId: String) {
        let needAuth : Bool = (UTRuntime.currentUser() != nil)
        let config = UTAPIConfig(apiName: "topics", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": FeedsService.pageCount,
            "id": userId
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                let array = response.result?.objectForKey("feeds") as? [AnyObject]
                if array != nil {
                    self.delegate?.didGetUserTopics?(true, page: page, hasNext: hasNext,data: self.processUserTopicsResults(array!), error: nil)
                } else {
                    self.delegate?.didGetUserTopics?(false, page: page, hasNext: false, data: nil, error: "Failed to get user topics")
                }
            } else {
                self.delegate?.didGetUserTopics?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getTopic(topicId: String) {
        let needAuth : Bool = UTRuntime.currentUser() == nil ? false: true
        let config = UTAPIConfig(apiName: topicId, apiNamespace: "feeds", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)

        request.startRequestWithMethod(.GET, callback: {
            (response: UTAPIResponse) in
            if response.success {
                if response.result != nil {
                    self.delegate?.didGetTopic?(true, data: FeedsService.processTopicResult(response.result!), error: nil)
                } else {
                    self.delegate?.didGetTopic?(false, data: nil, error: "Failed to get circle detail")
                }
                
            } else {
                self.delegate?.didGetTopic?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getTopicDetail(topicId: String) {
        let needAuth : Bool = UTRuntime.currentUser() == nil ? false: true
        let config = UTAPIConfig(apiName: "detail", apiNamespace: "feeds", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": topicId, "commentCount": FeedsService.pageCount]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                if response.result != nil {
                    let hasNext : Bool = response.result!.objectForKey("comments")?.objectForKey("hasNext") as? Bool ?? false
                    self.delegate?.didGetTopicDetail?(true, hasNext: hasNext, data: FeedsService.processTopicDetailResult(response.result!), error: nil)
                } else {
                    self.delegate?.didGetTopicDetail?(false, hasNext: false, data: nil, error: "Failed to get circle detail")
                }
                
            } else {
                self.delegate?.didGetTopicDetail?(false, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func postTopic(content: String, images: [String]) {
        let config : UTAPIConfig = UTAPIConfig(apiName: "post", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: true)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "content": content,
            "images": images.joinWithSeparator(",")
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didPostTopic?(true, topicId: response.result?.objectForKey("id") as? String, error: nil)
            } else {
                self.delegate?.didPostTopic?(false, topicId: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func postVideoTopic(content: String, videoUrl: String) {
        let config : UTAPIConfig = UTAPIConfig(apiName: "post", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: true)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "content": content,
            "videoUrl": videoUrl
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didPostTopic?(true, topicId: response.result?.objectForKey("id") as? String, error: nil)
            } else {
                self.delegate?.didPostTopic?(false, topicId: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func deleteTopic(id: String) {
        if UTRuntime.currentUser() == nil {
            return
        }
        let config : UTAPIConfig = UTAPIConfig(apiName: "delete", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: true)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["topicId": id]
        request.startRequestWithMethod(.POST, callback: {
            (response : UTAPIResponse) in
            if response.success {
                self.delegate?.didDeleteTopic?(true, topicId: id, error: nil)
            } else {
                self.delegate?.didDeleteTopic?(false, topicId: id, error: response.error?.userInfo["error"] as? String)
            }
        })
        
    }
    
    public func likeTopic(topicId: String) {
        let config : UTAPIConfig = UTAPIConfig(apiName: "like", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: true)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": topicId]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didLikeTopic?(true, topicId: topicId, error: nil)
            } else {
                self.delegate?.didLikeTopic?(false, topicId: topicId, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func dislikeTopic(topicId: String) {
        let config : UTAPIConfig = UTAPIConfig(apiName: "dislike", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: true)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": topicId]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didDislikeTopic?(true, topicId: topicId, error: nil)
            } else {
                self.delegate?.didDislikeTopic?(false, topicId: topicId, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func commentTopic(topicId: String, to: String?, content: String) {
        let config : UTAPIConfig = UTAPIConfig(apiName: "comment.post", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: true)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["topicId": topicId, "content": content]
        if to != nil {
            request.requestParams!["to"] = to!
        }
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didCommentTopic?(true, error: nil)
            } else {
                self.delegate?.didCommentTopic?(false, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func deleteComment(commentId: String, topicId: String) {
        let config : UTAPIConfig = UTAPIConfig(apiName: "comment.delete", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: true)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["topicId": topicId, "commentId": commentId]
        
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didDeleteTopicComment?(true, commentId: commentId, topicId: topicId, error: nil)
            } else {
                self.delegate?.didDeleteTopicComment?(false, commentId: commentId, topicId: topicId, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getComment(commentId: String) {
        let needAuth : Bool = (UTRuntime.currentUser() != nil)
        let config = UTAPIConfig(apiName: "comment", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["id": commentId]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let obj = response.result
                if obj != nil {
                    self.delegate?.didGetTopicComment?(true, data: FeedsService.processCommentResult(obj!), error: nil)
                } else {
                    self.delegate?.didGetTopicComment?(false, data: nil, error: "Failed to get topic comment")
                }
            } else {
                self.delegate?.didGetTopicComment?(false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func getTopicComments(page: Int, id: String) {
        let needAuth : Bool = (UTRuntime.currentUser() != nil)
        let config = UTAPIConfig(apiName: "comments", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": id,
            "index": page,
            "count": FeedsService.pageCount
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array = response.result?.objectForKey("data") as? [AnyObject]
                if array != nil {
                    let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                    
                    self.delegate?.didGetTopicComments?(true, page: page, hasNext: hasNext, data: FeedsService.processCommentsResult(array!), error: nil)
                } else {
                    self.delegate?.didGetTopicComments?(false, page: page, hasNext: false, data: nil, error: "Failed to get topic comments")
                }
            } else {
                self.delegate?.didGetTopicComments?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
//    func likeComment(commentId: String) {
//        let config = UTAPIConfig(apiName: "comment.like", apiNamespace: "topic", apiVersion: "1", apiIsNeedAuth: true)
//        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["id": commentId]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                self.delegate?.didLikeComment?(true, commentId: commentId, error: nil)
//            } else {
//                self.delegate?.didLikeComment?(false, commentId: commentId, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
//    
//    func dislikeComment(commentId: String) {
//        let config = UTAPIConfig(apiName: "comment.dislike", apiNamespace: "topic", apiVersion: "1", apiIsNeedAuth: true)
//        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
//        request.requestParams = ["id": commentId]
//        request.startRequestWithMethod(.POST, callback: {
//            (response: UTAPIResponse) in
//            if response.success {
//                self.delegate?.didDislikeComment?(true, commentId: commentId, error: nil)
//            } else {
//                self.delegate?.didDislikeComment?(false, commentId: commentId, error: response.error?.userInfo["error"] as? String)
//            }
//        })
//    }
    
    public func getTopicLikeUsers(topicId: String, page: Int) {
        let needAuth = (UTRuntime.currentUser() != nil)
        let config : UTAPIConfig = UTAPIConfig(apiName: "like.users", apiNamespace: "topic", apiVersion: "100", apiIsNeedAuth: needAuth)
        let request : UTAPIRequest = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": topicId,
            "index": page,
            "count": FeedsService.pageCount
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array = response.result?.objectForKey("data") as? [AnyObject]
                if array != nil {
                    let hasNext: Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                    var data = [UTUserInfo]()
                    for obj in array! {
                        data.append(UserService.processUserInfoResult(obj))
                    }
                    
                    self.delegate?.didGetTopicLikeUsers?(true, page: page, hasNext: hasNext, data: data, error: nil)
                } else {
                    self.delegate?.didGetTopicLikeUsers?(false, page: page, hasNext: false, data: nil, error: "Failed to get like list")
                }
            } else {
                self.delegate?.didGetTopicLikeUsers?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func reportContent(id: String, type: UTReportContentType) {
        let config = UTAPIConfig(apiName: "report", apiNamespace: "feeds", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": id,
            "type": type.rawValue
        ]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didReportContent?(true, contentId: id, error: nil)
            } else {
                self.delegate?.didReportContent?(false, contentId: id, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func processUserTopicsResults(array: [AnyObject]) -> [UTTopic] {
        var topics = [UTTopic]()
        for obj in array {
            let topic = FeedsService.processTopicResult(obj)
            let circleObject : AnyObject? = obj.objectForKey("circle")
            if circleObject != nil {
                let id : String = circleObject!.objectForKey("id") as? String ?? ""
                let name : String = circleObject!.objectForKey("name") as? String ?? ""
                var imageUrl : String = circleObject!.objectForKey("imageUrl") as? String ?? ""
                if !imageUrl.isEmpty {
                    imageUrl += "?imageView2/0/format/webp"
                }
                let thumbnail : String = circleObject!.objectForKey("thumbnail") as? String ?? ""
                let desc : String = circleObject!.objectForKey("desc") as? String ?? ""
                let userCount : Int = circleObject!.objectForKey("userCount") as? Int ?? 0
                let topicCount : Int = circleObject!.objectForKey("topicCount") as? Int ?? 0
                let joined : Bool = circleObject!.objectForKey("joined") as? Bool ?? false
                topic.circle = UTCircle(id: id, name: name, imageUrl: imageUrl, thumbnail: thumbnail, desc: desc, userCount: userCount, topicCount: topicCount, joined: joined)
            }
            topics.append(topic)
        }
        
        return topics
    }
    
    public class func processTopicResults(array: [AnyObject]) -> [UTTopic] {
        var topics = [UTTopic]()
        for obj in array {
            topics.append(processTopicResult(obj))
        }
        
        return topics
    }
    
    public class func processLikesResults(obj: AnyObject?) -> UTLikes {
        let count : Int = obj?.objectForKey("count") as? Int ?? 0
        let liked_by_user: Bool = obj?.objectForKey("liked_by_user") as? Bool ?? false
        var users : [UTUserInfo] = [UTUserInfo]()
        let likedUsers : [AnyObject] = obj?.objectForKey("users") as? [AnyObject] ?? []
        for user in likedUsers {
            users.append(UserService.processUserInfoResult(user))
        }
        
        return UTLikes(count: count, liked_by_user: liked_by_user, users: users)
    }
    
    public class func processTopicResult(obj: AnyObject) -> UTTopic {
        let id : String = obj.objectForKey("id") as? String ?? ""
        let content : String = obj.objectForKey("content") as? String ?? ""
        var images : [String] = [String]()
        for image in (obj.objectForKey("images") as? [String] ?? []) {
            images.append(image + "?imageView2/0/format/webp")
        }
//        let images : [String] = obj.objectForKey("images") as? [String] ?? []
        let commentCount : Int = obj.objectForKey("commentCount") as? Int ?? 0
        let likeCount : Int = obj.objectForKey("likeCount") as? Int ?? 0
        let createdAt : Double = obj.objectForKey("createdAt") as? Double ?? 1440726638.0
        let user : AnyObject? = obj.objectForKey("publisher")
        let publisher : UTUserInfo = UserService.processUserInfoResult(user)
        let likes : UTLikes = FeedsService.processLikesResults(obj.objectForKey("likes"))
        let videoUrl : String = obj.objectForKey("videoUrl") as? String ?? ""
        return UTTopic(id: id, content: content, images: images, commentCount: commentCount, likeCount: likeCount, createdAt: createdAt, publisher: publisher, likes: likes, videoUrl: videoUrl)
    }
    
    public class func processTopicDetailResult(obj: AnyObject) -> UTTopicDetail {
        let topic : UTTopic = FeedsService.processTopicResult(obj)
        
        let comments : [UTTopicComment] = FeedsService.processCommentsResult((obj.objectForKey("comments")?.objectForKey("data") as? [AnyObject]) ?? [])
        return UTTopicDetail(topic: topic, comments: comments)
    }
    
    public class func processCommentResult(obj: AnyObject) -> UTTopicComment {
        let id : String = obj.objectForKey("id") as? String ?? ""
        let content : String = obj.objectForKey("content") as? String ?? ""
        let publisher : UTUserInfo = UserService.processUserInfoResult(obj.objectForKey("publisher"))
        var receiver : UTUserInfo? = nil
        if let temp = (obj.objectForKey("receiver") as? [String: AnyObject])  {
            receiver = UserService.processUserInfoResult(temp)
        }
        let likedCount : Int = obj.objectForKey("likedCount") as? Int ?? 0
        let liked_by_user : Bool = obj.objectForKey("liked_by_user") as? Bool ?? false
        let createdAt : Double = obj.objectForKey("createdAt") as? Double ?? 1442432391
        
        return UTTopicComment(id: id, content: content, publisher: publisher, receiver: receiver, likedCount: likedCount, liked_by_user: liked_by_user, createdAt: createdAt)
    }
    
    public class func processCommentsResult(array: [AnyObject]) -> [UTTopicComment] {
        var comments : [UTTopicComment] = [UTTopicComment]()
        for obj in array {
            comments.append(FeedsService.processCommentResult(obj))
        }
        
        return comments
    }
}