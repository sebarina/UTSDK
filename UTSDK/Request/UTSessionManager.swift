//
//  UTSessionManager.swift
//  UTNetwork
//
//  Created by Sebarina Xu on 5/24/16.
//  Copyright © 2016 liufan. All rights reserved.
//

import Foundation
import UTNetwork

public class UTSessionManager {
    private static var mutipleSessions : [String: UTNetworkSession] = [:]
    private static var lock = NSLock()
    
    public class func getSession(baseUrl: String) -> UTNetworkSession {
        lock.lock()
        if mutipleSessions[baseUrl] == nil {
            let session = UTNetworkSession(baseUrl: baseUrl, timeout: 10)
            mutipleSessions[baseUrl] = session
        }
        let returnedSession = mutipleSessions[baseUrl]!
        lock.unlock()
        return returnedSession
        
    }
    
    
}