//
//  MultipartBuilder.swift
//  src
//
//  Created by Anil Kumar BP on 11/21/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation

class MultipartBuilder {
    
    internal var body = String()
    internal var _contents = [String: AnyObject]()
    internal var _boundary: String?
    
    // Set the Boundary
    func setBoundary(boundary: String = "") {
        self._boundary = boundary
    }
    
    // Boundary, return the boundary
    func boundary() -> String {
        return self._boundary!
    }
    
    // Set Body for the MultiPart
    func setBody(body: [String: AnyObject]) -> MultipartBuilder {
        self.body = jsonToString(body)
        return self
    }
    
    // Retreive body
    func getBody() -> String {
        return self.body
    }
    
    // Function always use provided $filename. In cases when it's empty, for string content or when name cannot be
    // Automatically discovered the $filename will be set to attachment name.
    // If attachment name is not provided, it will be randomly generated.
    func add(content: AnyObject, fileName: String = "", headers: [String: String]?=nil , name: String = "") -> MultipartBuilder {
       
        var element: [String: AnyObject] = ["":""]
        // If file content is a string
        if(content is String){
            element["contents"] = content
        }

        // If content is a NSURL
        if(content is NSURL){
            var error: NSError?
            let fileName = content.path!!.lastPathComponent
            let mimeType = "text/csv"
            let fieldName = "uploadFile"
            element["contents"] = String(contentsOfFile: content.path!!, encoding: NSUTF8StringEncoding, error: &error)!
        }
//        
//        // Set the filename if not empty
//        if(fileName != "") {
//            element["filename"] = fileName
//        }
//        
//        // Set the headers if not empty
//        if(!headers!.isEmpty) {
//            element["headers"] = headers
//        }
//        
        self._contents = element
        
        return self
    }
    
    // Get the contents
    func contents() -> [String:AnyObject] {
        return self._contents
    }
    
    // Create a request
    func request(url: String, method: String = "POST", completion: (respsone: ApiResponse) -> Void) {
//        var stream = self.requestBody()
        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
        let boundaryConstant = "Boundary-"+uniqueId
//        var dataString: String = String()
        
        var headers: [String: String] = [:]
        headers["Content-type"] = "application/octet-stream; boundary=" + boundaryConstant

        let fileName = self._contents["filename"]
        let contents = self._contents["contents"]
        let mimeType = "application/octet-stream"
        let fieldName = "uploadFile"

        var error: NSError?
        var dataString = "--\(boundaryConstant)\r\n"
        dataString += "Content-Type: application/json\r\n"
        dataString += "Content-Disposition: form-data; name=\"json\"; filename=\"request.json\"\r\n"
        dataString += "Content-Length: 51\r\n"
        dataString += "\r\n"
        dataString += "{\"to\":{\"phoneNumber\":\"foo\"},\"faxResolution\":\"High\"}\r\n"
        dataString += "--\(boundaryConstant)--\r\n"
        dataString += "Content-Type: \(mimeType)\r\n\r\n"
        dataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        dataString += String(stringInterpolationSegment: contents)
        dataString += "\r\n"
        dataString += "--\(boundaryConstant)--\r\n"
        
        
        //        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        
        
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

    // Create the requestBody
//    func requestBody() -> [String: AnyObject] {
//        let uniqueId = NSProcessInfo.processInfo().globallyUniqueString
//        let boundaryConstant = "Boundary-"+uniqueId
//        var headers: [String: String] = [:]
//        headers["Content-type"] = "multipart/form-data; boundary=" + boundaryConstant
//        
//        let fileName = self._contents["filename"]
//        let contents = self._contents["contents"]
//        let mimeType = "text/csv"
//        let fieldName = "uploadFile"
//
//        
//        var error: NSError?
//        var dataString = "--\(boundaryConstant)\r\n"
//        dataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
//        dataString += "Content-Type: \(mimeType)\r\n\r\n"
//        dataString += contents
//        dataString += "\r\n"
//        dataString += "--\(boundaryConstant)--\r\n"
//        
//        
//        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        
//    }
    
    
}