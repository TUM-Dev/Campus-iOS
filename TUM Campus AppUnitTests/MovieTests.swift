//  TUM_Campus_AppUnitTests.swift
//  TUM Campus AppUnitTests
//
//  Created by Max Muth on 15/01/2017.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import XCTest

@testable import Campus

class MockReceiver: TumDataReceiver {
    let mockReceiveData: (([DataElement], XCTestExpectation) -> Void)?
    let expectation: XCTestExpectation?
    
    init(receiveData: @escaping (([DataElement], XCTestExpectation) -> Void), expectation: XCTestExpectation) {
        self.mockReceiveData = receiveData
        self.expectation = expectation
    }
    
    func receiveData(_ data: [DataElement]) {
        self.mockReceiveData?(data, self.expectation!)
    }
}

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
            var movies = [Movie]()
            for element in data {
                if let movieElement = element as? Movie {
                    movies.append(movieElement)
                }
            }
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
