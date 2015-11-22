//
//  main.swift
//  src
//
//  Created by Anil Kumar BP on 11/17/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation


println("Hello, World!")


var app_key: String = ""
var app_secret = ""
var username = ""
var password = ""
var response: ApiResponse


var rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_PRODUCTION)
println("SDK initialized")
var platform = rcsdk.platform()
var subscription = rcsdk.createSubscription()
println("Platform singleton")
response = platform.login(username, ext:"101", password: password)
println(response.getDict())

// Test a GET request


platform.get("/account/~/extension/~/call-log")
    {
        (transaction) in
        println("Response is :")
        println(transaction.getResponse())
        println("API response is :")
        println(transaction.getDict())
    }
sleep(2)

print("completed call-logs")

// add events to the subscription object
subscription.addEvents(
    [
        "/restapi/v1.0/account/~/extension/~/presence",
        "/restapi/v1.0/account/~/extension/~/message-store"
    ])

subscription.register()
    {
        (transaction) in
        println("Response is :")
        println(transaction.getResponse())
        println("API response is :")
        println(transaction.getDict())
    }
sleep(2)

platform.post("/account/~/extension/~/ringout", body :
                [ "to": ["phoneNumber": "18315941779"],
                  "from": ["phoneNumber": "15856234190"],
                  "callerId": ["phoneNumber": ""],
                  "playPrompt": "true"
                ])
    {
        (transaction) in
        println("Response is :")
        println(transaction.getResponse())
        println("API response is :")
        println(transaction.getDict())
        
    }

sleep(5)

print("completed ring-out")

platform.delete("/account/~/extension/~/ringout", query :
    [
        "ringoutId": "264"
    ])
    {
        (transaction) in
        println("Response is :")
        println(transaction.getResponse())
        println("API response is :")
        println(transaction.getDict())
        
    }
sleep(5)

print("ring-out cancelled")



