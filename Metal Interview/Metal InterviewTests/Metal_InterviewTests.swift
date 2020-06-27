//
//  Metal_InterviewTests.swift
//  Metal InterviewTests
//
//  Created by Hrishi Amravatkar on 6/26/20.
//  Copyright © 2020 Hrishi Amravatkar. All rights reserved.
//

import XCTest
@testable import Metal_Interview

class Metal_InterviewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let expectation = self.expectation(description: "Stubs network call")
        let movieApi = MovieApi()
        movieApi.getListMovies({ (movies: [Movie]) in
           print(movies)
           XCTAssertTrue(movies.count > 0)
           expectation.fulfill()
        }) { (error) in
           expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
