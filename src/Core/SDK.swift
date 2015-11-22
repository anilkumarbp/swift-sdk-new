//
//  SDK.swift
//  src
//
//  Created by Anil Kumar BP on 11/17/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation

// Object representation of a Standard Development Kit for RingCentral
class SDK {
    
    // Set constants for SANDBOX and PRODUCTION servers.
    static var VERSION: String = ""
    static var RC_SERVER_PRODUCTION: String = "https://platform.ringcentral.com"
    static var RC_SERVER_SANDBOX: String = "https://platform.devtest.ringcentral.com"
    
    // Platform variable, version, and current Subscriptions
    var _platform: Platform
    //    var subscription: Subscription?
    let server: String
    var _client: Client
    var serverVersion: String!
    var versionString: String!
    var logger: Bool = false
    
    
    
    init(appKey: String, appSecret: String, server: String) {
        self._client = Client()
        _platform = Platform(appKey: appKey, appSecret: appSecret, server: server)
        self.server = server
    }
    
    
    /// Returns the Platform with the specified appKey and appSecret.

    /// :returns: A Platform to access the methods of the SDK
    func platform() -> Platform {
        return self._platform
    }
    
    
    
    //  Create a subscription.
    
    //  :returns: Subscription object that has been currently created
        func createSubscription() -> Subscription {
            return Subscription(platform: self._platform)
        }
    
    
    
}