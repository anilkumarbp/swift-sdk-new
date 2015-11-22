//
//  Platform.swift
//  src
//
//  Created by Anil Kumar BP on 11/17/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation

/// Platform used to call HTTP request methods.
class Platform {
    
    // platform Constants
    let ACCESS_TOKEN_TTL = "3600"; // 60 minutes
    let REFRESH_TOKEN_TTL = "604800"; // 1 week
    let TOKEN_ENDPOINT = "/restapi/oauth/token";
    let REVOKE_ENDPOINT = "/restapi/oauth/revoke";
    let API_VERSION = "v1.0";
    let URL_PREFIX = "/restapi";
    
    
    // Platform credentials
    var auth: Auth
    var client: Client
    let server: String
    let appKey: String
    let appSecret: String
    //    var subscription: Subscription?


    /// Constructor for the platform of the SDK
    ///
    /// :param: appKey      The appKey of your app
    /// :param: appSecet    The appSecret of your app
    /// :param: server      Choice of PRODUCTION or SANDBOX
    init(appKey: String, appSecret: String, server: String) {
        self.appKey = appKey
        self.appSecret = appSecret
        self.server = server
        self.auth = Auth()
        self.client = Client()
        
    }
    
    
    // Returns the auth object
    ///
    func returnAuth() -> Auth {
        return self.auth
    }
    
    /// createUrl
    ///
    /// @param: path              The username of the RingCentral account
    /// @param: options           The password of the RingCentral account
    /// @response: ApiResponse    The password of the RingCentral account
    func createUrl(path: String, options: [String: AnyObject]) -> String {
        println("Inside CreateURL")
        var builtUrl = ""
        if(options["skipAuthCheck"] === true){
            builtUrl = builtUrl + self.server + path
            println("The Built url is :"+builtUrl)
            return builtUrl
        }
        builtUrl = builtUrl + self.server + self.URL_PREFIX + "/" + self.API_VERSION + path
        println("The Built url is :"+builtUrl)
        return builtUrl
    }
    
    /// Authorizes the user with the correct credentials
    ///
    /// :param: username    The username of the RingCentral account
    /// :param: password    The password of the RingCentral account
    func login(username: String, ext: String, password: String) -> Transaction {
        let response = requestToken(self.TOKEN_ENDPOINT,body: [
            "grant_type": "password",
            "username": username,
            "extension": ext,
            "password": password,
            "access_token_ttl": self.ACCESS_TOKEN_TTL,
            "refresh_token_ttl": self.REFRESH_TOKEN_TTL
            ])
        println("Successfull return from requestToken")
        self.auth.setData(response.getDict())
        println("Is access token valid : ",self.auth.accessTokenValid())
        println("The auth data is : ")
        println(response.JSONStringify(response.getDict(), prettyPrinted: true))
        return response
    }
    
    
    /// Refreshes the Auth object so that the accessToken and refreshToken are updated.
    ///
    /// **Caution**: Refreshing an accessToken will deplete it's current time, and will
    /// not be appended to following accessToken.
    func refresh() -> Transaction {
        //        let transaction:
        if(!self.auth.refreshTokenValid()){
            NSException(name: "Refresh token has expired", reason: "reason", userInfo: nil).raise()
        }
        let response = requestToken(self.TOKEN_ENDPOINT,body: [
            "grant_type": "refresh_token",
            "refresh_token": self.auth.refreshToken(),
            "access_token_ttl": self.ACCESS_TOKEN_TTL,
            "refresh_token_ttl": self.REFRESH_TOKEN_TTL
            ])
        println("Successfull return from requestToken")
        println(response.getDict())
        self.auth.setData(response.getDict())
        println("Is access token valid",self.auth.accessTokenValid())
        println("The auth data is",self.auth.data())
        return response
    }
    
    /// func inflateRequest ()
    ///
    /// @param: request     NSMutableURLRequest
    /// @param: options     list of options
    /// @response: NSMutableURLRequest
    func inflateRequest(path: String, request: NSMutableURLRequest, options: [String: AnyObject]) -> NSMutableURLRequest {
        var check = 0
        if options["skipAuthCheck"] == nil {
            ensureAuthentication()
            let authHeader = self.auth.tokenType() + " " + self.auth.accessToken()
            request.setValue(authHeader, forHTTPHeaderField: "Authorization")
            //            check = 1
        }
        //        let url = createUrl(path,check: check,options: ["addServer": true])
        //        let request = NSMutableURLRequest(URL:url)
        return request
    }
    
    
    
    
    /// func sendRequest ()
    ///
    /// @param: request     NSMutableURLRequest
    /// @param: options     list of options
    /// @response: ApiResponse
    func sendRequest(request: NSMutableURLRequest, path: String, options: [String: AnyObject]!, completion: (transaction: Transaction) -> Void) {
        client.send(inflateRequest(path, request: request, options: options)) {
            (t) in
            completion(transaction: t)
            
        }
    }
    
    func sendRequest(request: NSMutableURLRequest, path: String, options: [String: AnyObject]!) -> Transaction {
        return client.send(inflateRequest(path, request: request, options: options))
    }
    
    ///  func requestToken ()
    ///
    /// @param: path    The token endpoint
    /// @param: array   The body
    /// @return ApiResponse
    func requestToken(path: String, body: [String:AnyObject]) -> Transaction {
        let authHeader = "Basic" + " " + self.apiKey()
        var headers: [String: String] = [:]
        headers["Authorization"] = authHeader
        headers["Content-type"] = "application/x-www-form-urlencoded;charset=UTF-8"
        var options: [String: AnyObject] = [:]
        options["skipAuthCheck"] = true
        let urlCreated = createUrl(path,options: options)
        let request = self.client.createRequest("POST", url: urlCreated, query: nil, body: body, headers: headers)
        return self.sendRequest(request, path: path, options: options)
    }
    
    
    
    
    /// Base 64 encoding
    func apiKey() -> String {
        let plainData = (self.appKey + ":" + self.appSecret as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    
    
       /// Logs the user out of the current account.
    ///
    /// Kills the current accessToken and refreshToken.
    func logout() -> Transaction {
        let response = requestToken(self.TOKEN_ENDPOINT,body: [
            "token": self.auth.accessToken()
            ])
        self.auth.reset()
        return response
    }
    
    
    /// Returns whether or not the current accessToken is valid.
    ///
    /// :return: A boolean to check the validity of token.
    func isTokenValid() -> Bool {
        return false
    }
    
    
    /// Returns whether or not the current Platform has been authorized with a user.
    ///
    /// :return: A boolean to check the validity of authorization.
    func isAuthorized() -> Bool {
        return auth.isAccessTokenValid()
    }
    
    /// Tells the user if the accessToken is valed
    ///
    ///
    func ensureAuthentication() {
        println("Inside EnsureAuthentication")
        if (!self.auth.accessTokenValid()) {
            refresh()
        }
    }
    

    
    // Generic Method calls  ( HTTP ) GET
    func get(url: String, query: [String: String] = ["":""], completion: (transaction: Transaction) -> Void) {
        apiCall([
            "method": "GET",
            "url": url,
            "query": query
            ])
            {
                (t) in
                completion(transaction: t)
                
            }
    }
    
    // Generic Method calls  ( HTTP ) without completion handler
    func get(url: String, query: [String: String] = ["":""]) -> Transaction {
        // Check if query is empty
        
        return apiCall([
            "method": "GET",
            "url": url,
            "query": query
            ])
    }
    
    
    // Generic Method calls  ( HTTP ) POST
    func post(url: String, body: [String: AnyObject] = ["":""], completion: (transaction: Transaction) -> Void) {
        apiCall([
            "method": "POST",
            "url": url,
            "body": body
            ])
            {
                (t) in
                completion(transaction: t)
                
            }
    }
    
    // Generic Method calls  ( HTTP ) PUT
    func put(url: String, body: [String: AnyObject] = ["":""], completion: (transaction: Transaction) -> Void) {
        apiCall([
            "method": "PUT",
            "url": url,
            "body": body
            ])
            {
                (t) in
                completion(transaction: t)
                
            }
    }
    
    // Generic Method calls ( HTTP ) DELETE
    func delete(url: String, query: [String: String] = ["":""], completion: (transaction: Transaction) -> Void) {
        apiCall([
            "method": "DELETE",
            "url": url,
            "query": query
            ])
            {
                (t) in
                completion(transaction: t)
                
        }
    }

    // Generic Method calls ( HTTP ) without the completion handler
    

    // Generic Method Calls
    
    /// HTTP request method for GET
    ///
    /// :param: url         URL for GET request
    /// :param: query       List of queries for GET request
    //    func get(url: String, query: [String: String] = ["": ""]) {
    //        apiCall([
    //            "method": "GET",
    //            "url": url,
    //            "query": query
    //            ])
    //    }
    //
    //    /// HTTP request method for PUT
    //    ///
    //    /// :param: url         URL for PUT request
    //    /// :param: body        Body for PUT request
    //    func put(url: String, body: String = "") {
    //        apiCall([
    //            "method": "PUT",
    //            "url": url,
    //            "body": body
    //            ])
    //    }
    //
    //    /// HTTP request method for POST
    //    ///
    //    /// :param: url         URL for POST request
    //    /// :param: body        Body for POST request
    //    func post(url: String, body: String = "") {
    //        apiCall([
    //            "method": "POST",
    //            "url": url,
    //            "body": body
    //            ])
    //    }
    //
    //    /// HTTP request method for DELETE
    //    ///
    //    /// :param: url         URL for DELETE request
    //    func delete(url: String) {
    //        apiCall([
    //            "method": "DELETE",
    //            "url": url,
    //            ])
    //    }
    //
    //    /// Generic HTTP request
    //    ///
    //    /// :param: options     List of options for HTTP request
    func apiCall(options: [String: AnyObject]) -> Transaction {
        var method = ""
        var url = ""
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        var query: [String: String]?
        //            var body: AnyObject = ""
        var body = [String: AnyObject]()
        if let m = options["method"] as? String {
            method = m
        }
        if let u = options["url"] as? String {
            url =  u
        }
        if let h = options["headers"] as? [String: String] {
            headers = h
        }
        if let q = options["query"] as? [String: String] {
            query = q
        }
        else {
            query = nil
        }
        if let b = options["body"] as? [String: AnyObject] {
            //                if let check = b as? NSDictionary {
            body = options["body"] as! [String: AnyObject]
            //                } else {
            //                body = options["body"] as! [String: AnyObject]
        }
        
        return sendRequest(self.client.createRequest(method, url: url, query: query, body: body, headers: headers), path: url, options: options)
    }
    
    
    /// Generic HTTP request with completion handler
    ///
    /// :param: options         List of options for HTTP request
    /// :param: completion      Completion handler for HTTP request
    func apiCall(options: [String: AnyObject], completion: (transaction: Transaction) -> Void) {
        println("Inside apiCall")
        var method = ""
        var url = ""
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        var query: [String: String]?
        //            var body: AnyObject = ""
        var body = [String: AnyObject]()
        if let m = options["method"] as? String {
            method = m
        }
        if let u = options["url"] as? String {
            url =  u
        }
        if let h = options["headers"] as? [String: String] {
            headers = h
        }
        if let q = options["query"] as? [String: String] {
            query = q
        }
        if let b = options["body"] as? [String: AnyObject] {
            //                if let check = b as? NSDictionary {
            body = options["body"] as! [String: AnyObject]
            //                } else {
            //                body = options["body"] as! [String: AnyObject]
        }
        
        let urlCreated = createUrl(url,options: options)
        
        sendRequest(self.client.createRequest(method, url: urlCreated, query: query, body: body, headers: headers), path: url, options: options) {
            (t) in
            completion(transaction: t)
            
        }
        
    }    
}