//
//  TipTest.swift
//  Fooienpot-IOSTests
//
//  Created by Fhict on 09/01/2018.
//  Copyright © 2018 Mick. All rights reserved.
//

import XCTest
@testable import Fooienpot_IOS

class TipTest: XCTestCase {
    var tip1:Tip!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        tip1 = Tip(a: "10", d: "test", c: "test")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        tip1 = nil
    }
    
    func testGetAmount() {
        let amount = "20"
        tip1.setAmount(a: amount)
        let value = tip1.getAmount()
        
        XCTAssertTrue(amount == value)
    }
 
    
}
