//
//  OrderApiTests.swift
//  CloudKitchenTests
//
//  Created by Hrishi Amravatkar on 6/9/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import XCTest

class OrderApiTests: XCTestCase {

    func testFetchOrders() throws {
        let expectation = self.expectation(description: "Stubs network call")
        let orderApi = OrderApi()
        orderApi.fetchOrders(success: { (orders: [Order]) in
            print(orders)
            XCTAssertNotNil(orders)
            expectation.fulfill()
        }) { (error) in
            print(error)
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
