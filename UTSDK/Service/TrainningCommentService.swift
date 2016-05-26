//
//  TrainningCommentService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 3/3/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

@objc protocol TrainningCommentServiceDelegate {
    optional func didGetRepliedComments(success: Bool, page: Int, hasNext: Bool, data: [UTTrainningComment]?, error: String?)
    optional func didGetUnrepliedComments(success: Bool, page: Int, hasNext: Bool, data: [UTTrainningComment]?, error: String?)
    optional func didPostTrainningComment(success: Bool, commentId: String, error: String?)
}


class TrainningCommentService : NSObject {
    private weak var delegate : TrainningCommentServiceDelegate?
    static let pageCount : Int = 20
    
    init(delegate: TrainningCommentServiceDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    func getRepliedComments(trainningId: String, page: Int) {
        let config = UTAPIConfig(apiName: "comments.replied", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": trainningId,
            "index": page,
            "count": TrainningCommentService.pageCount
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                if let array = response.result?.objectForKey("data") as? [AnyObject] {
                    self.delegate?.didGetRepliedComments?(true, page: page, hasNext: hasNext, data: TrainningCommentService.processCommentResults(array), error: nil)
                } else {
                    self.delegate?.didGetRepliedComments?(false, page: page, hasNext: false, data: nil, error: "获取数据失败")
                }
            } else {
                self.delegate?.didGetRepliedComments?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    func getUnrepliedComments(trainningId: String, page: Int) {
        let config = UTAPIConfig(apiName: "comments.unreplied", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": trainningId,
            "index": page,
            "count": TrainningCommentService.pageCount
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                if let array = response.result?.objectForKey("data") as? [AnyObject] {
                    self.delegate?.didGetUnrepliedComments?(true, page: page, hasNext: hasNext, data: TrainningCommentService.processCommentResults(array), error: nil)
                } else {
                    self.delegate?.didGetUnrepliedComments?(false, page: page, hasNext: false, data: nil, error: "获取数据失败")
                }
            } else {
                self.delegate?.didGetUnrepliedComments?(false, page: page, hasNext: false, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    func postComment(id: String, grade: Int, content: String) {
        let config = UTAPIConfig(apiName: "comment.post", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": id,
            "grade": grade,
            "content": content
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) -> Void in
            if response.success {
                self.delegate?.didPostTrainningComment?(true, commentId: response.result?.objectForKey("id") as? String ?? "", error: nil)
            } else {
                self.delegate?.didPostTrainningComment?(false, commentId: "", error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    class func processCommentResults(array: [AnyObject]) -> [UTTrainningComment] {
        var comments = [UTTrainningComment]()
        for obj in array {
            let id : String = obj.objectForKey("objectId") as? String ?? ""
            let publisher : UTUserInfo = UserService.processUserInfoResult(obj.objectForKey("publisher"))
            let grade : Int = obj.objectForKey("grade") as? Int ?? 0
            let trainningId : String = obj.objectForKey("trainningId") as? String ?? ""
            let content : String = obj.objectForKey("content") as? String ?? ""
            let createdAt : Double = obj.objectForKey("createdAt") as? Double ?? 1440726638.0
            let comment : UTTrainningComment = UTTrainningComment(id: id, publisher: publisher, grade: grade, trainningId: trainningId, content: content, createdAt: createdAt)
            if let reply = obj.objectForKey("reply") {
                comment.reply = TrainningCommentService.processCommentReplyResult(reply)
            }
            comments.append(comment)
        }
        return comments
    }
    
    class func processCommentReplyResult(obj: AnyObject) -> UTTrainningCommentReply {
        let id : String = obj.objectForKey("objectId") as? String ?? ""
        let publisher : UTUserInfo = UserService.processUserInfoResult(obj.objectForKey("publisher"))
        let content : String = obj.objectForKey("content") as? String ?? ""
        let createdAt : Double = obj.objectForKey("createdAt") as? Double ?? 1440726638.0
        let hasAttachment : Bool = obj.objectForKey("hasAttachment") as? Bool ?? false
        
        let commentReply =  UTTrainningCommentReply(id: id, publisher: publisher, content: content, createdAt: createdAt)
        if hasAttachment {
            let type = obj.objectForKey("attachment")?.objectForKey("type") as? String ?? ""
            let data = obj.objectForKey("attachment")?.objectForKey("data") as? String ?? ""
            commentReply.attachment = UTTrainningCommentAttachment(type: type, data: data)
            
        }
        return commentReply
    }
}