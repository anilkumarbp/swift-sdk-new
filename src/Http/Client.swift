//
//  Client.swift
//  src
//
//  Created by Anil Kumar BP on 11/17/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation


class Client {
    
    internal var useMock: Bool = false
    internal var appName: String
    internal var appVersion: String
    
    internal var mockRegistry: AnyObject?
    
    // Constants
    var contentType = "Content-Type"
    var jsonContentType = "application/json"
    var multipartContentType = "multipart/mixed"
    var urlencodedContentType = "application/x-www-form-urlencoded"
    var utf8ContentType = "charset=UTF-8"
    var accept = "Accept"
    
    
    
    init(appName: String = "", appVersion: String = "") {
        self.appName = appName
        self.appVersion = appVersion
    }
    
    func getMockRegistry() -> AnyObject? {
        return mockRegistry
    }
    
    func useMock(flag: Bool = false) -> Client {
        self.useMock = flag
        return self
    }
    
    
    
    /// Generic HTTP request
    ///
    /// :param: options         List of options for HTTP request
    /// :param: completion      Completion handler for HTTP request
    func send(request: NSMutableURLRequest) -> ApiResponse {
        if self.useMock {
            return sendMock(request)
        } else {
            return sendReal(request)
        }
    }
    
    /// Generic HTTP request with completion handler
    ///
    /// :param: options         List of options for HTTP request
    /// :param: completion      Completion handler for HTTP request
    func send(request: NSMutableURLRequest, completion: (response: ApiResponse) -> Void) {
        if self.useMock {
            sendMock(request) {
                (r) in
                completion(response: r)
            }
        } else {
            sendReal(request) {
                (r) in
                completion(response: r)
            }
        }
    }
    
    
    func sendReal(request: NSMutableURLRequest, completion: (response: ApiResponse) -> Void) {
//        var trans = ApiResponse(request: request)
        println("inside sendReal :")
        var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            var errors: NSError?
            let dict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
            var apiresponse = ApiResponse(request: request, data: data, response: response, error: error, dict: dict)
            completion(response:apiresponse)
        }
        task.resume()
    }
    
    
    func sendMock(request: NSMutableURLRequest, completion: (transaction: ApiResponse) -> Void) {
        
    }
    
    func sendReal(request: NSMutableURLRequest) -> ApiResponse {
        
        var response: NSURLResponse?
        var error: NSError?
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        println((response as! NSHTTPURLResponse).statusCode)
        var errors: NSError?
        let dict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        var apiresponse = ApiResponse(request: request, data: data, response: response, error: error, dict: dict)
//        trans.setData(data)
//        trans.setDict(readdata)
//        trans.setResponse(response)
//        trans.setError(error)

        return apiresponse
    }
    
    func sendMock(request: NSMutableURLRequest) -> ApiResponse {
        
        var data: NSData?
        var response: NSURLResponse?
        var error: NSError?
        var dict: NSDictionary?
        var trans = ApiResponse(request: request, data: data, response: response, error: error, dict: dict)
        return trans
    }
    
    
    func jsonToString(json: [String: AnyObject]) -> String {
        var result = "{"
        var delimiter = ""
        for key in json.keys {
            result += delimiter + "\"" + key + "\":"
            var item = json[key]
            if let check = item as? String {
                result += "\"" + check + "\""
            } else {
                if let check = item as? [String: AnyObject] {
                    result += jsonToString(check)
                } else if let check = item as? [AnyObject] {
                    result += "["
                    delimiter = ""
                    for item in check {
                        result += "\n"
                        result += delimiter + "\""
                        result += item.description + "\""
                        delimiter = ","
                    }
                    result += "]"
                } else {
                    result += item!.description
                }
            }
            delimiter = ","
        }
        result = result + "}"
        
        println("Body String is :"+result)
        return result
    }
    
    
    // Create a request
    func createRequest(method: String, url: String, query: [String: String]?=nil, body: [String: AnyObject]?, headers: [String: String]) -> NSMutableURLRequest {
        
        var truncatedBodyFinal: String = ""
        var truncatedQueryFinal: String = ""
        var queryFinal: String = ""

        if let q = query {
            queryFinal = "?"
            
            for key in q.keys {
                if(q[key] == "") {
                    queryFinal = "&"
                }
                else {
                    queryFinal = queryFinal + key + "=" + q[key]! + "&"
                }
            }
            truncatedQueryFinal = queryFinal.substringToIndex(queryFinal.endIndex.predecessor())
            println("The truncated queryFInal is :"+truncatedQueryFinal)
            
            println("Non-Empty Query List")
        }

        // Body
        var bodyString: String
        var bodyFinal: String = ""

        // Check if the body is empty
        if (body?.count == 0) {
            println("Body is Empty")
            truncatedBodyFinal = ""
            
        } else {
            
            // Check if body is for authentication
            if (headers["Content-type"] == "application/x-www-form-urlencoded;charset=UTF-8") {
                if let q = body {
                    bodyFinal = "?"
                    for key in q.keys {
                        bodyFinal = bodyFinal + key + "=" + (q[key]! as! String) + "&"
                    }
                    truncatedBodyFinal = bodyFinal.substringToIndex(bodyFinal.endIndex.predecessor())
                    println(truncatedBodyFinal)
                }
            }
                
            // Format the body
            else {
                if let json = body as AnyObject? {
                    println("Non-Empty Body")
                    bodyFinal = jsonToString(json as! [String : AnyObject])
                    truncatedBodyFinal = bodyFinal
                    println(truncatedBodyFinal)
                }
//                else if (json = body as String)
            }
        }
        
        
        // Create a NSMutableURLRequest
        var request = NSMutableURLRequest()
        
        // check for certain things
        println("Inside Create Request")
        println("The url is :"+url)
        println("The queryFinal is :"+queryFinal)
        
        if let nsurl = NSURL(string: url + truncatedQueryFinal) {
            request = NSMutableURLRequest(URL: nsurl)
            request.HTTPMethod = method
            request.HTTPBody = truncatedBodyFinal.dataUsingEncoding(NSUTF8StringEncoding)
            for key in headers.keys {
                request.setValue(headers[key], forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
}