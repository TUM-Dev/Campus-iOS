//  TUM_Campus_AppUnitTests.swift
//  TUM Campus AppUnitTests
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
