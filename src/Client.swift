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
    func send(request: NSMutableURLRequest) -> Transaction {
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
    func send(request: NSMutableURLRequest, completion: (transaction: Transaction) -> Void) {
        if self.useMock {
            sendMock(request) {
                (t) in
                completion(transaction: t)
            }
        } else {
            sendReal(request) {
                (t) in
                completion(transaction: t)
            }
        }
    }
    
    
    func sendReal(request: NSMutableURLRequest, completion: (transaction: Transaction) -> Void) {
        var trans = Transaction(request: request)
        println("inside sendReal :")
        var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            trans.setData(data)
            //            println("The data is: ",trans.getData())
            trans.setResponse(response)
            //            println("The response is :",trans.getResponse())
            trans.setError(error)
            var errors: NSError?
            let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
            trans.setDict(readdata)
            completion(transaction:trans)
        }
        task.resume()
    }
    
    
    func sendMock(request: NSMutableURLRequest, completion: (transaction: Transaction) -> Void) {
        
    }
    
    func sendReal(request: NSMutableURLRequest) -> Transaction {
        
        var trans = Transaction(request: request)
        var response: NSURLResponse?
        var error: NSError?
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        //                println(data)
        println((response as! NSHTTPURLResponse).statusCode)
        
        if (response as! NSHTTPURLResponse).statusCode / 100 != 2 {
            //                    (data, response, error) in
            trans.setData(data)
            trans.setResponse(response)
            trans.setError(error)
            return trans
        }
        //
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        
        trans.setData(data)
        trans.setDict(readdata)
        trans.setResponse(response)
        trans.setError(error)
        //        var trans = Transaction(request: request)
        //        var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
        //            (data, response, error) in
        //            trans.setData(data)
        //            trans.setResponse(response)
        //            trans.setError(error)
        //        }
        //        task.resume()
        return trans
    }
    
    func sendMock(request: NSMutableURLRequest) -> Transaction {
        var trans = Transaction(request: request)
        return trans
    }
    
    private func jsonToString(json: [String: AnyObject]) -> String {
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
        
        return result
    }
    
    
    // Create a request
    func createRequest(method: String, url: String, query: [String: String]?=nil, body: [String: AnyObject]?, headers: [String: String]) -> NSMutableURLRequest {
        
        //        createUrl()
        //      var properties = parseProperties(method,url,query,body,headers)
        var truncatedBodyFinal: String = ""
        var truncatedQueryFinal: String = ""
        var queryFinal: String = ""
        
        // Check if the Query is empty
        //        if (query?.isEmpty == 1) {
        //            println("Query is empty")
        //            queryFinal = ""
        //        }
        //        else {
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
        //        }
        
        
        
        
        // Headers
        //        if (headers.isEmpty) {
        //            var headers: [String: String] = [:]
        //            headers[contentType] = jsonContentType
        //            headers[accept] = jsonContentType
        //            println(headers[contentType])
        //            println(headers[accept])
        //        }
        //
        
        
        
        // Body
        var bodyString: String
        var bodyFinal: String = ""
        //        if (headers["Content-type"] == "application/x-www-form-urlencoded;charset=UTF-8") {
        //
        //            //            var bodyString: String
        //            //
        //            if let q = body {
        //                //                bodyString = jsonToString(json)
        //                //            } else {
        //                //                bodyString = body as! String
        //                //            }
        //
        //                //
        //                //            if let q: [String: AnyObject] = body {
        //                bodyFinal = "?"
        //                ////            if let body: AnyObject = body {
        //                //            if let body as [String: AnyObject] {
        //                for key in q.keys {
        //                    bodyFinal = bodyFinal + key + "=" + (q[key]! as! String) + "&"
        //                }
        //                truncatedBodyFinal = bodyFinal.substringToIndex(bodyFinal.endIndex.predecessor())
        //                //            println(truncatedBodyFinal)
        //            }
        //        }
        
        // Check if the body is empty
        if (body?.count == 0) {
            println("Body is Empty")
            truncatedBodyFinal = ""
        }
            //
            //
        else {
            
            // Check if body is for authentication
            if (headers["Content-type"] == "application/x-www-form-urlencoded;charset=UTF-8") {
                
                //            var bodyString: String
                //
                if let q = body {
                    //                bodyString = jsonToString(json)
                    //            } else {
                    //                bodyString = body as! String
                    //            }
                    
                    //
                    //            if let q: [String: AnyObject] = body {
                    bodyFinal = "?"
                    ////            if let body: AnyObject = body {
                    //            if let body as [String: AnyObject] {
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
                }
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
            //            request.setValue(urlencodedContentType, forHTTPHeaderField: contentType)
            //            request.setValue(jsonContentType, forHTTPHeaderField: accept)
        }
        
        return request
        
    }
    
    
    // makes a request
    func requestFactory(method: String, url: String, query: [String: String]?, body: AnyObject, headers: [String: String]) -> NSMutableURLRequest {
        
        var queryFinal: String = ""
        
        
        
        if let q = query {
            queryFinal = "?"
            for key in q.keys {
                queryFinal = queryFinal + key + "=" + q[key]! + "&"
            }
        }
        
        var bodyString: String
        
        if let json = body as? [String: AnyObject] {
            bodyString = jsonToString(json)
        } else {
            bodyString = body as! String
        }
        
        var request = NSMutableURLRequest()
        
        if let nsurl = NSURL(string: url + queryFinal) {
            request = NSMutableURLRequest(URL: nsurl)
            request.HTTPMethod = method
            request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
            for key in headers.keys {
                request.setValue(headers[key], forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
    func getRequestHeaders() {
        
    }
    
    func parseProperties(method: String, url: String, query: [String: String]?, body: [String:AnyObject], headers: [String: String]) {
        
        // URL
        
        //        var queryFinal: String = ""
        //        var url = ""
        //        if let q = query {
        //            queryFinal = "?"
        //            for key in q.keys {
        //                queryFinal = queryFinal + key + "=" + q[key]! + "&"
        //            }
        //        }
        //
        //        url= url + queryFinal
        //
        //        // Body
        //
        //        var bodyString: String
        //
        //        if let json = body as? [String: AnyObject] {
        //            bodyString = jsonToString(json)
        //        } else {
        //            bodyString = body as! String
        //        }
        //
        //        // Headers
        //
        ////        var headers: [String: String] = [String:String]()
        //        headers["Content-Type"]: urlencodedContentType
        //        headers["Accept"]: jsonContentType
        //
        //
        
    }
    
    
}