//
//  SDKTest.swift
//  src
//
//  Created by Anil Kumar BP on 11/22/15.
//  Copyright (c) 2015 Anil Kumar BP. All rights reserved.
//

import Cocoa
import XCTest
import SDK

class SDKTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
         sleep(5)
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testConstructor() {
        var sdk = SDK(appKey: "foo", appSecret: "bar", server: SDK.RC_SERVER_PRODUCTION)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
