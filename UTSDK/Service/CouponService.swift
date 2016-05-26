//
//  CouponService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 5/17/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation

@objc public protocol CouponServiceDelegate {
    optional func didGetAvailabelCoupons(success: Bool, hasNext: Bool, page: Int, data: [UTCoupon]?, error: String?)
    optional func didGetUserCoupons(success: Bool, hasNext: Bool, page: Int, data: [UTCoupon]?, error: String?)
    
    optional func didBuyCoupon(success: Bool, id: String, error: String?)
}


public class CouponService: NSObject {
    private weak var delegate : CouponServiceDelegate?
    
    static let pageCount : Int = 15
    
    public init(delegate: CouponServiceDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    public func getUserCertainCoupons() {
        let config = UTAPIConfig(apiName: "coupons", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": 0,
            "count": 2
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
//                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                let array : [AnyObject] = response.result?.objectForKey("data") as? [AnyObject] ?? []
                self.delegate?.didGetUserCoupons?(true, hasNext: false, page: 0, data: CouponService.processCouponsArray(array), error: nil)
            } else {
                self.delegate?.didGetUserCoupons?(false, hasNext: false, page: 0, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public func getAvailabelCoupons(page: Int) {
        let config = UTAPIConfig(apiName: "available", apiNamespace: "coupon", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": CouponService.pageCount
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                let array : [AnyObject] = response.result?.objectForKey("data") as? [AnyObject] ?? []
                self.delegate?.didGetAvailabelCoupons?(true, hasNext: hasNext, page: page, data: CouponService.processCouponsArray(array), error: nil)
            } else {
                self.delegate?.didGetAvailabelCoupons?(false, hasNext: false, page: 0, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public func getUserCoupons(page: Int) {
        let config = UTAPIConfig(apiName: "coupons", apiNamespace: "user", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "index": page,
            "count": CouponService.pageCount
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                let hasNext : Bool = response.result?.objectForKey("hasNext") as? Bool ?? false
                let array : [AnyObject] = response.result?.objectForKey("data") as? [AnyObject] ?? []
                self.delegate?.didGetUserCoupons?(true, hasNext: hasNext, page: page, data: CouponService.processCouponsArray(array), error: nil)
            } else {
                self.delegate?.didGetUserCoupons?(false, hasNext: false, page: 0, data: nil, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public func buyCoupon(id: String) {
        let config = UTAPIConfig(apiName: "buy", apiNamespace: "coupon", apiVersion: "100", apiIsNeedAuth: true)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = [
            "id": id
        ]
        request.startRequestWithMethod(.POST) { (response: UTAPIResponse) in
            if response.success {
                self.delegate?.didBuyCoupon?(true, id: id, error: nil)
            } else {
                self.delegate?.didBuyCoupon?(false, id: id, error: response.error?.userInfo["error"] as? String)
            }
        }
    }
    
    public class func processCouponsArray(array: [AnyObject]) -> [UTCoupon] {
        var coupons = [UTCoupon]()
        for obj in array {
            coupons.append(CouponService.processCouponResult(obj))
        }
        return coupons
    }
    
    public class func processCouponResult(obj: AnyObject) -> UTCoupon {
        let id : String = obj.objectForKey("objectId") as? String ?? ""
        let value : Int = obj.objectForKey("value") as? Int ?? 0
        let atLeast : Int = obj.objectForKey("atLeast") as? Int ?? 0
        let rangeType : UTCouponRangeType = UTCouponRangeType(rawValue: obj.objectForKey("rangeType") as? String ?? "none") ?? .None
        let rangeValues : [String] = obj.objectForKey("rangeValue") as? [String] ?? []
        let usage : String = obj.objectForKey("usage") as? String ?? ""
        let price : Int = obj.objectForKey("price") as? Int ?? 0
        let code : String = obj.objectForKey("code") as? String ?? ""
        let startAt : Double = obj.objectForKey("startAt") as? Double ?? 14000000
        let endAt : Double = obj.objectForKey("endAt") as? Double ?? 14000000
        let stock : Int = obj.objectForKey("stock") as? Int ?? 0
        let quota : Int = obj.objectForKey("quota") as? Int ?? 0
        var imageUrl : String = obj.objectForKey("imageUrl") as? String ?? ""
        if !imageUrl.isEmpty {
            imageUrl += "?imageView2/0/format/webp"
        }
        
        return UTCoupon(id: id, value: value, atLeast: atLeast, rangeType: rangeType, rangeValues: rangeValues, usage: usage, price: price, code: code, startAt: startAt, endAt: endAt, stock: stock, quota: quota, imageUrl: imageUrl)
    }
}