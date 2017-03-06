//  TUM_Campus_AppUnitTests.swift
//  TUM Campus AppUnitTests
//
//  Created by Max Muth on 15/01/2017.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import XCTest

@testable import Campus

class MovieTests: XCTestCase {
    var manager = TumDataManager(user: nil)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOnlyUpcomingMovies() {
        func receiveData(_ data: [DataElement], expectation: XCTestExpectation) {
            let movies = data.flatMap { $0 as? Movie }
            let dateNow = Date()
            let upcomingMovies = movies.filter() { movie in
                return movie.airDate >= dateNow
            }
            XCTAssertTrue(movies.isEmpty || movies.count == upcomingMovies.count, "Movies are all in the future or there are no future movies.")
            expectation.fulfill()
        }
        
        let expect = expectation(description: "Fetch movies and check whether they are all in the future")
        let tmpReceiver = MockReceiver(receiveData: receiveData, expectation: expect)
        
        manager.getMovies(tmpReceiver)
        waitForExpectations(timeout: 5) { error in }
        
    }
    
}
