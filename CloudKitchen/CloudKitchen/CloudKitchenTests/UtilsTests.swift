//
//  UtilsTests.swift
//  CloudKitchenTests
//
//  Created by Hrishi Amravatkar on 6/7/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import XCTest


class UtilsTests: XCTestCase {

    func testCalculateOrderValueNotNil() throws {
        let orderDict : [String : Any]  = ["id": "690b85f7-8c7d-4337-bd02-04e04454c826",
        "name" : "test",
        "temp" : "cold",
        "shelfLife" : 100,
        "decayRate" : 0.1]
        let order = Order(orderDict)
        let value = Utils.calculateOrderValue(order)
        
        XCTAssertNotNil(value, "value cannot be nil")
    }
    
}
