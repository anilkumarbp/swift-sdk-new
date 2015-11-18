//
//  Auth.swift
//  src
//
//  Created by Anil Kumar BP on 11/17/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation

/// Authorization object for the platform.
class Auth {
    
    static let MAINCOMPANY = "101"
    
    // Authorization information
    var token_type: String?
    
    var access_token: String?
    var expires_in: Double = 0
    var expire_time: Double = 0
    
    //    var app_key: String?
    //    var app_secret: String?
    
    var refresh_token: String?
    var refresh_token_expires_in: Double = 0
    var refresh_token_expire_time: Double = 0
    
    
    var scope: String?
    var owner_id: String?
    
    //    let username: String
    //    let password: String
    //    let ext: String
    //    let server: String
    //
    //    var authenticated: Bool = false
    
    
    //Default constructor for the
    init() {
        //        reset()
        self.token_type = nil
        
        self.access_token = nil
        self.expires_in = 0
        self.expire_time = 0
        
        self.refresh_token = nil
        self.refresh_token_expires_in = 0
        self.refresh_token_expire_time = 0
        
        self.scope = nil
        self.owner_id = nil
        
    }
    
    /// Set the authentication data.
    ///
    func setData(data: Dictionary<String, AnyObject>) -> Auth {
        if data.count < 0 {
            println("The count is :",data.count)
            return self
        }
        
        // Misc
        
        if let token_type = data["token_type"] as? String {
            self.token_type = token_type
        }
        if let owner_id = data["owner_id"] as? String {
            self.owner_id = owner_id
        }
        if let scope = data["scope"] as? String {
            self.scope = scope
        }
        
        // Access Token
        if let access_token = data["access_token"] as? String {
            self.access_token = access_token
        }
        if let expires_in = data["expires_in"] as? Double {
            self.expires_in = expires_in
        }
        if data["expire_time"] == nil {
            if data["expires_in"] != nil {
                let time = NSDate().timeIntervalSince1970
                self.expire_time = time + self.expires_in
            }
        }else if let expire_time = data["expire_time"] as? Double {
            self.expire_time = expire_time
        }
        
        // Refresh Token
        if let access_token = data["refresh_token"] as? String {
            self.refresh_token = access_token
        }
        if let refresh_token_expires_in = data["refresh_token_expires_in"] as? Double {
            self.refresh_token_expires_in = refresh_token_expires_in
        }
        if data["refresh_token_expire_time"] == nil {
            if data["refresh_token_expires_in"] != nil {
                let time = NSDate().timeIntervalSince1970
                self.refresh_token_expire_time = time + self.refresh_token_expires_in
            }
        }else if let refresh_token_expire_time = data["refresh_token_expire_time"] as? Double {
            self.refresh_token_expire_time = refresh_token_expire_time
        }
        return self
    }
    
    
    
    
    /// Reset the authentication data.
    ///
    
    func reset() -> Void {
        self.token_type = " ";
        
        self.access_token = "";
        self.expires_in = 0;
        self.expire_time = 0;
        
        self.refresh_token = "";
        self.refresh_token_expires_in = 0;
        self.refresh_token_expire_time = 0;
        
        self.scope = "";
        self.owner_id = "";
        
        //        return self
    }
    
    /// Return the authnetication data
    func data()-> [String: AnyObject] {
        
        var data: [String: AnyObject] = [:]
        data["token_type"]=self.token_type
        data["access_token"]=self.access_token
        data["expires_in"]=self.expires_in
        data["expire_time"]=self.expire_time
        data["refresh_token"]=self.refresh_token
        data["refresh_token_expires_in"]=self.refresh_token_expires_in
        data["refresh_token_expire_time"]=self.refresh_token_expire_time
        data["scope"]=self.scope
        data["owner_id"]=self.owner_id
        
        return data
    }
    
    
    
    /// Logs the user in with the current credentials.
    ///
    /// :param: key The appKey for RC account
    /// :param: secret The appSecret for RC account
    //    func login(key: String, secret: String) -> (NSData?, NSURLResponse?, NSError?) {
    //        self.app_key = key
    //        self.app_secret = secret
    //
    //        // URL api call for getting token
    ////        let url = NSURL(string: server + "/restapi/oauth/token")
    //
    //        // Setting up User info for parsing
    //        let bodyString = "grant_type=password&" + "username=" + self.username + "&" + "password=" + self.password + "&" + "extension=" + self.ext
    //        let plainData = (key + ":" + secret as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    //        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    //
    //        // Setting up HTTP request
    //        let request = NSMutableURLRequest(URL: url!)
    //        request.HTTPMethod = "POST"
    //        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
    //        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
    //        request.setValue("application/json", forHTTPHeaderField: "Accept")
    //        request.setValue("Basic" + " " + base64String, forHTTPHeaderField: "Authorization")
    //
    //        // Sending HTTP request
    //        var response: NSURLResponse?
    //        var error: NSError?
    //        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
    //
    //        if (response as! NSHTTPURLResponse).statusCode / 100 != 2 {
    //            return (data, response, error)
    //        }
    //
    //        var errors: NSError?
    //        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
    //
    //        // Setting authentication information
    //        self.authenticated = true
    //        self.access_token = readdata["access_token"] as? String
    //        self.expires_in = readdata["expires_in"] as! Double
    //        self.refresh_token = readdata["refresh_token"] as? String
    //        self.refresh_token_expires_in = readdata["refresh_token_expires_in"] as! Double
    //        self.token_type = readdata["token_type"] as? String
    //        self.scope = readdata["scope"] as? String
    //        self.owner_id = readdata["owner_id"] as? String
    //        let time = NSDate().timeIntervalSince1970
    //        self.expire_time = time + self.expires_in
    //        self.refresh_token_expire_time = time + self.refresh_token_expires_in
    //
    //        return (data, response, error)
    //
    //    }
    //
    //    /// Refreshes the access_token and refresh_token with the current refresh_token
    //    ///
    //    /// :returns: tuple for responses
    //    func refresh() -> (NSData?, NSURLResponse?, NSError?) {
    //        // URL api call for getting token
    //        let url = NSURL(string: server + "/oauth/token")
    //
    //        // Setting up User info for parsing
    //        var bodyString = "grant_type=refresh_token&" + "username=" + self.username + "&" + "password=" + self.password + "&" + "extension=" + self.ext + "&" + "refresh_token=" + self.refresh_token!
    //        let plainData = (self.app_key! + ":" + self.app_secret! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    //        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    //
    //        // Setting up HTTP request
    //        let request = NSMutableURLRequest(URL: url!)
    //        request.HTTPMethod = "POST"
    //        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
    //        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
    //        request.setValue("application/json", forHTTPHeaderField: "Accept")
    //        request.setValue("Basic" + " " + base64String, forHTTPHeaderField: "Authorization")
    //
    //        // Sending HTTP request
    //        var response: NSURLResponse?
    //        var error: NSError?
    //        let data: NSData! = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
    //        var errors: NSError?
    //        let readdata = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errors) as! NSDictionary
    //
    //        // Setting authentication information
    //        self.authenticated = true
    //        self.access_token = readdata["access_token"] as? String
    //        self.expires_in = readdata["expires_in"] as! Double
    //        self.refresh_token = readdata["refresh_token"] as? String
    //        self.refresh_token_expires_in = readdata["refresh_token_expires_in"] as! Double
    //        self.token_type = readdata["token_type"] as? String
    //        self.scope = readdata["scope"] as? String
    //        self.owner_id = readdata["owner_id"] as? String
    //        let time = NSDate().timeIntervalSince1970
    //        self.expire_time = time + self.expires_in
    //        self.refresh_token_expire_time = time + self.refresh_token_expires_in
    //
    //        return (data, response, error)
    //
    //    }
    
    /// Checks whether or not the access token is valid
    ///
    /// :returns: A boolean for validity of access token
    func isAccessTokenValid() -> Bool {
        let time = NSDate().timeIntervalSince1970
        if(self.expire_time > time) {
            return true
        }
        return false
    }
    
    /// Checks for the validity of the refresh token
    ///
    /// :returns: A boolean for validity of the refresh token
    func isRefreshTokenVald() -> Bool {
        return false
    }
    
    /// Revokes the access_token
    ///
    /// :returns: tuple for response
    //    func revokeToken() -> (NSData?, NSURLResponse?, NSError?) {
    //        let url = NSURL(string: server + "/oauth/revoke")
    //
    //
    //        // Setting up User info for parsing
    //        let bodyString = "token=" + access_token!
    //        let plainData = (app_key! + ":" + app_secret! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
    //        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    //
    //        // Setting up request
    //        let request = NSMutableURLRequest(URL: url!)
    //        request.HTTPMethod = "POST"
    //        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
    //        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
    //        request.setValue("application/json", forHTTPHeaderField: "Accept")
    //        request.setValue("Basic" + " " + base64String, forHTTPHeaderField: "Authorization")
    //
    //        var response: NSURLResponse?
    //        var error: NSError?
    //        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
    //
    //        self.access_token = nil
    //        self.expires_in = 0
    //        self.expire_time = 0
    //        self.refresh_token = nil
    //        self.refresh_token_expires_in = 0
    //        self.refresh_token_expire_time = 0
    //
    //        return (data, response, error)
    //    }
    //
    /// Returns the 'access token'
    ///
    /// :returns: String of 'access token'
    func accessToken() -> String {
        return self.access_token!
    }
    
    /// Returns the 'refresh token'
    ///
    /// :returns: String of 'refresh token'
    func refreshToken() -> String {
        return self.refresh_token!
    }
    
    /// Returns the 'tokenType'
    ///
    /// :returns: String of 'token Type'
    func tokenType() -> String {
        return self.token_type!
    }
    
    /// Returns bool if 'accessTokenValid'
    ///
    /// :returns: Bool if 'access token valid'
    func accessTokenValid() -> Bool {
        let time = NSDate().timeIntervalSince1970
        if self.expire_time > time {
            return true
        }
        return false
    }
    
    
    
    /// Returns bool if 'refreshTokenValid'
    ///
    /// :returns: String of 'refresh token valid'
    func refreshTokenValid() -> Bool {
        let time = NSDate().timeIntervalSince1970
        if self.refresh_token_expire_time > time {
            return true
        }
        return false
    }
    
    /// Returns the 'username'
    ///
    /// :returns: String of 'username'
    //    func getUsername() -> String {
    //        return self.username
    //    }
    //
    //    /// Returns the access token
    ///
    /// :returns: String of access token
    //    func getAppKey() -> String {
    //        return self.app_key!
    //    }
    
    /// Returns the 'app secret'
    ///
    /// :returns: String of 'app secret'
    //    func getAppSecret() -> String {
    //        return self.app_secret!
    //    }
    //
    /// Returns the 'extension'
    ///
    //    /// :returns: String of 'extension'
    //    func getExtension() -> String {
    //        return self.ext
    //    }
    
}