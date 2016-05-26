//
//  LFShareApi.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/14/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

public class LFShareApi {
    
    public class func weiboShare(shareData: ShareData) -> Bool {
        let request = WBSendMessageToWeiboRequest()
        let message : WBMessageObject = WBMessageObject()
        message.text = shareData.desc
        
        switch shareData.contentType {
        case .Image:  // 分享图片
            let imageObject = WBImageObject()
            imageObject.imageData = UIImagePNGRepresentation(shareData.shareImage)
            message.imageObject = imageObject
            break
        case .Video: // 分享视频
            let videoObject = WBVideoObject()
            let url : String = shareData.videoUrl ?? ""
            videoObject.videoUrl = url
            videoObject.videoStreamUrl = url
            videoObject.videoLowBandStreamUrl = url
            videoObject.videoLowBandUrl = url
            videoObject.thumbnailData = UIImagePNGRepresentation(shareData.thumbnail)
            videoObject.objectID = "video \(url)"
            videoObject.title = shareData.title
            videoObject.description = shareData.desc
            message.mediaObject = videoObject
            break
        case .WebPage: // 分享网页
            let webObject = WBWebpageObject()
            webObject.title = shareData.title
            webObject.description = shareData.desc
            webObject.thumbnailData = UIImagePNGRepresentation(shareData.thumbnail)
            webObject.objectID = "App_Share"
            webObject.webpageUrl = shareData.webPageUrl ?? ""
            message.mediaObject = webObject
            break
        }
        request.message = message
        return WeiboSDK.sendRequest(request)
    }
    
    public class func weixinShare(shareData: ShareData, shareType : WeixinShareType) -> Bool{
        let req : SendMessageToWXReq = SendMessageToWXReq()
        req.message = WXMediaMessage()
        
        req.message.title = shareData.title
        req.message.description = shareData.desc
        req.message.setThumbImage(shareData.thumbnail)
        
        switch shareData.contentType {
        case .Image:
            let imageObject = WXImageObject()
            imageObject.imageData = UIImageJPEGRepresentation( shareData.shareImage, 1)
            
            req.message.mediaObject = imageObject
            break
        case .Video:
            let videoObject = WXVideoObject()
            videoObject.videoUrl = shareData.videoUrl ?? ""
            req.message.mediaObject = videoObject
            break
        case .WebPage:
            let webObject = WXWebpageObject()
            webObject.webpageUrl = shareData.webPageUrl
            req.message.mediaObject = webObject
            break
        }
        if shareType == .SessionShare {
            req.scene = 0
        } else if shareType == .MomentsShare{
            req.message.title = shareData.desc
            req.scene = 1
            
        } else {
            req.scene = 2
        }
        return WXApi.sendReq(req)
        
    }
    
    public class func qqShare(shareData: ShareData) {
        LFTencentAuthorizeApi.getInstance().authorizeTencentApi()
        
        switch shareData.contentType {
        case .Image:  // 分享图片
            let imageObject = QQApiImageObject(data: UIImagePNGRepresentation(shareData.shareImage), previewImageData: UIImagePNGRepresentation(shareData.thumbnail), title: shareData.title, description: shareData.desc)
            let request = SendMessageToQQReq(content: imageObject)
            QQApiInterface.sendReq(request)
            break
        case .Video: // 分享视频
            let videoObject = QQApiVideoObject(URL: NSURL(string: shareData.videoUrl ?? ""), title: shareData.title, description: shareData.desc, previewImageData: UIImagePNGRepresentation(shareData.thumbnail), targetContentType: QQApiURLTargetTypeVideo)
            let request = SendMessageToQQReq(content: videoObject)
            QQApiInterface.sendReq(request)
            break
        case .WebPage: // 分享网页
            let webObject = QQApiNewsObject(URL: NSURL(string: shareData.webPageUrl ?? ""), title: shareData.title, description: shareData.desc, previewImageData: UIImagePNGRepresentation(shareData.thumbnail), targetContentType: QQApiURLTargetTypeNews)
            let request = SendMessageToQQReq(content: webObject)
            QQApiInterface.sendReq(request)
            break
        }
        
        
    }
    
    public class func qqzoneShare(shareData: ShareData) {
        LFTencentAuthorizeApi.getInstance().authorizeTencentApi()
        switch shareData.contentType {
        case .Image:  // 分享图片
            let imageObject = QQApiImageObject(data: UIImagePNGRepresentation(shareData.shareImage), previewImageData: UIImagePNGRepresentation(shareData.thumbnail), title: shareData.title, description: shareData.desc)
            let request = SendMessageToQQReq(content: imageObject)
            QQApiInterface.SendReqToQZone(request)
            break
        case .Video: // 分享视频
            let videoObject = QQApiVideoObject(URL: NSURL(string: shareData.videoUrl ?? ""), title: shareData.title, description: shareData.desc, previewImageData: UIImagePNGRepresentation(shareData.thumbnail), targetContentType: QQApiURLTargetTypeVideo)
            let request = SendMessageToQQReq(content: videoObject)
            QQApiInterface.SendReqToQZone(request)
            break
        case .WebPage: // 分享网页
            let webObject = QQApiNewsObject(URL: NSURL(string: shareData.webPageUrl ?? ""), title: shareData.title, description: shareData.desc, previewImageData: UIImagePNGRepresentation(shareData.thumbnail), targetContentType: QQApiURLTargetTypeNews)
            let request = SendMessageToQQReq(content: webObject)
            QQApiInterface.SendReqToQZone(request)
            break
        }
        
        
    }
}