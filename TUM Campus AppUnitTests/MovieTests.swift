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
    
    func testReceivedDataAreMovies() {
        func receiveData(_ data: [DataElement], expectation: XCTestExpectation) {
            let movies = data.flatMap { $0 as? Movie }
            XCTAssertTrue(data.count == movies.count, expectation.description)
            expectation.fulfill()
        }
        
        let expect = expectation(description: "Received data items can be initialized to movies")
        let tmpReceiver = MockReceiver(receiveData: receiveData, expectation: expect)
        
        manager.getMovies(tmpReceiver)
        waitForExpectations(timeout: 5) { error in }
    }
    
    func testOnlyUpcomingMovies() {
        func receiveData(_ data: [DataElement], expectation: XCTestExpectation) {
            let movies = data.flatMap { $0 as? Movie }
            let dateNow = Date()
            let upcomingMovies = movies.filter() { movie in
                return movie.airDate >= dateNow
            }
            XCTAssertTrue(movies.isEmpty || movies.count == upcomingMovies.count, expectation.description)
            expectation.fulfill()
        }
        
        let expect = expectation(description: "Movies are all in the future or there are no movies")
        let tmpReceiver = MockReceiver(receiveData: receiveData, expectation: expect)
        
        manager.getMovies(tmpReceiver)
        waitForExpectations(timeout: 5) { error in }
    }
    
}
