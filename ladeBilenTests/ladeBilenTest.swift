//
//  ladeBilenTest.swift
//  ladeBilenTests
//
//  Created by Ludvig Ellevold on 08.03.2018.
//  Copyright © 2018 Ludvig Ellevold. All rights reserved.
//

import XCTest
@testable import ladeBilen

class ladeBilenTest: XCTestCase {
    var app: App?
    
    override func setUp() {
        super.setUp()
        app = App()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testInitializationWithCache(){
        let user: User = User(uid: "UID", email: "Email", firstname: "Firstname", lastname: "Lastname", fastCharge: true, parkingFee: true, cloudStorage: true, notifications: true, notificationDuration: 30, connector: [14, 39])
        
        app?.user = user
        
        
        app?.initializeApplication(done: { code in
            XCTAssertEqual(code, 0)
        })
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
