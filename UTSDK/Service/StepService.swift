//
//  WorkoutService.swift
//  UTeacher
//
//  Created by Sebarina Xu on 9/6/15.
//  Copyright (c) 2015 liufan. All rights reserved.
//

import Foundation

@objc public protocol StepServiceDelegate {
    optional func didGetSteps(success: Bool, data: [UTStep]?, forWorkout: String, error: String?)
}

public class StepService: NSObject {
    private weak var delegate : StepServiceDelegate?
    
    public init(delegate: StepServiceDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    public func getWorkoutSteps(workout: UTWorkout) {
        let config = UTAPIConfig(apiName: "steps", apiNamespace: "trainning", apiVersion: "100", apiIsNeedAuth: false)
        let request = UTAPIUtil.getAPIRequestByConfig(config)
        request.requestParams = ["ids": workout.steps.joinWithSeparator(",")]
        request.startRequestWithMethod(.POST, callback: {
            (response: UTAPIResponse) in
            if response.success {
                let array = response.result as? [AnyObject]
                if array != nil {
                    self.delegate?.didGetSteps?(true, data: self.processStepsResult(array!), forWorkout: workout.id, error: nil)
                } else {
                    self.delegate?.didGetSteps?(false, data: nil, forWorkout: workout.id, error: "Failed to get workout steps")
                }
                
            } else {
                self.delegate?.didGetSteps?(false, data: nil, forWorkout: workout.id, error: response.error?.userInfo["error"] as? String)
            }
        })
    }
    
    public func processStepsResult(array: [AnyObject]) -> [UTStep] {
        var steps = [UTStep]()
        for obj in array {
            let id : String = obj.objectForKey("id") as? String ?? ""
            let name : String = obj.objectForKey("name") as? String ?? ""
            var thumbnail : String = (obj.objectForKey("thumbnail") as? String) ?? ""
            if !thumbnail.isEmpty {
                thumbnail += "?imageView2/0/format/webp"
            }
            var imageUrl : String = (obj.objectForKey("imageUrl") as? String) ?? ""
            if !imageUrl.isEmpty {
                imageUrl += "?imageView2/0/format/webp"
            }
            let videoUrl : String = (obj.objectForKey("videoUrl") as? String) ?? ""
            let group : Int = obj.objectForKey("group") as? Int ?? 0
            let count : Int = obj.objectForKey("count") as? Int ?? 0
            let duration : Int = obj.objectForKey("duration") as? Int ?? 0
            let type : UTStepType = UTStepType(rawValue: obj.objectForKey("type") as? String ?? "action") ?? .Rest
            let points : String = obj.objectForKey("points") as? String ?? ""
            let attention : String = obj.objectForKey("attention") as? String ?? ""
            let benefits : String = obj.objectForKey("benefits") as? String ?? ""
            let level : UTStepLevel = processLevelResult(obj.objectForKey("level"))
            let category : UTStepCategory = processCategoryResult(obj.objectForKey("category"))
            
            steps.append(UTStep(id: id, name: name, thumbnail: thumbnail, imageUrl: imageUrl, videoUrl: videoUrl, group: group, count: count, duration: duration, type: type, points: points, attention: attention, benefits: benefits, level: level, category: category))
        }
        
        return steps
    }
    
    public func processLevelResult(obj: AnyObject?) -> UTStepLevel {
        if obj == nil {
            return UTStepLevel(id: "", name: "", slug: "")
        }
        let id : String = obj!.objectForKey("objectId") as? String ?? ""
        let name : String = obj!.objectForKey("title") as? String ?? ""
        let slug : String = obj!.objectForKey("slug") as? String ?? ""
        
        return UTStepLevel(id: id, name: name, slug: slug)
    }
    
    public func processCategoryResult(obj: AnyObject?) -> UTStepCategory {
        let id : String = obj?.objectForKey("objectId") as? String ?? ""
        let name : String = obj?.objectForKey("title") as? String ?? ""
        let slug : String = obj?.objectForKey("slug") as? String ?? ""
        
        return UTStepCategory(id: id, name: name, slug: slug)
    }
    
}