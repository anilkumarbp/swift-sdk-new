//
//  main.swift
//  src
//
//  Created by Anil Kumar BP on 11/17/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation


println("Hello, World!")


var app_key: String = "MNJx4H4cTR-02_zPnsTJ5Q"
var app_secret = "7CJKigzBTzOvzTDPP1-C3AARDYohOlSaCLcvgzpNZUzw"
var username = "15856234190"
var password = "sandman1!"
var response: Transaction


var rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_SANDBOX)
println("SDK initialized")
var platform = rcsdk.getPlatform()
println("Platform singleton")
response = platform.login(username, ext:"101", password: password)
println(response.getDict())

// Test a GET request


platform.get("/account/~/extension/~/call-log"
    //                    query: [
    //                    "extensionNumber": "101",
    //                    "type": "voice"
    //                    ]
    )
    {
        (transaction) in
        //        println("Data is :")
        //        println(transaction.getData())
        println("Response is :")
        println(transaction.getResponse())
        //        println(transaction.getRequest()?.allHTTPHeaderFields)
        println("API response is :")
        println(transaction.getDict())
        
}
sleep(5)

print("completed")

