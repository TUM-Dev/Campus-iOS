//  TUM_Campus_AppUnitTests.swift
//  TUM Campus AppUnitTests
//
//  Created by Max Muth on 15/01/2017.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import XCTest
import Sweeft

@testable import Campus

class MovieTests: XCTestCase {
    
    lazy var manager: TumDataManager = {
        return Bundle.main.url(forResource: "config", withExtension: "json")
            .flatMap({ try? Data(contentsOf: $0) })
            .flatMap(JSON.init(data:))
            .flatMap { TumDataManager(user: PersistentUser.value.user, json: $0) }!
    }()
    
    func testOnlyUpcomingMovies() {
        
        let expectation = self.expectation(description: "Movies are all in the future or there are no movies")
        
        manager.movieManager.fetch().onSuccess(in: .main) { movies in
            let dateNow = Date()
            let upcomingMovies = movies.filter { movie in
                return movie.airDate >= dateNow
            }
            XCTAssertTrue(movies.isEmpty || movies.count == upcomingMovies.count, expectation.description)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5) { error in }
    }
    
}
