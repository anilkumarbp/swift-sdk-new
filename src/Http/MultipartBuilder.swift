//
//  MultipartBuilder.swift
//  src
//
//  Created by Anil Kumar BP on 11/21/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Foundation

class MultipartBuilder {
    
    internal var body = [String: AnyObject]()
    internal var contents = [String: AnyObject]()
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
        self.body = body
        return self
    }
    
    // Retreive body 
    func getBody() -> [String: AnyObject] {
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
        
        // Set the filename if not empty
        if(fileName != "") {
            element["filename"] = fileName
        }
        
        // Set the headers if not empty
        if(!headers!.isEmpty) {
            element["headers"] = headers
        }
        
        self.contents = element
        
        return self
    }
    
    
    
}