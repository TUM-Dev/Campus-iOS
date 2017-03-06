//  TUM_Campus_AppUnitTests.swift
//  TUM Campus AppUnitTests
//
//  Created by Max Muth on 15/01/2017.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import XCTest

@testable import Campus

class MovieTests: XCTestCase {
    
    var movies = [Movie]()
    var manager = TumDataManager(user: nil)
    
    var testGetAllMoviesExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testOnlyUpcomingMovies() {
        self.testGetAllMoviesExpectation = expectation(description: "Fetch movies and check whether they are all in the future")
        manager.getMovies(self)
        waitForExpectations(timeout: 5) { error in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
        }
        
    }
    
}

extension MovieTests: TumDataReceiver {
    
    func receiveData(_ data: [DataElement]) {
        for element in data {
            if let movieElement = element as? Movie {
                movies.append(movieElement)
            }
        }
        let dateNow = Date()
        let upcomingMovies = movies.filter() { movie in
            return movie.airDate >= dateNow
        }
        XCTAssertTrue(movies.isEmpty || movies.count == upcomingMovies.count)
        self.testGetAllMoviesExpectation?.fulfill()
    }
    
}
