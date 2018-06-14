//
//  AutomatedScreenshots.swift
//  AutomatedScreenshots
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

//@testable import Campus

class ScreenshotUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAllScreenshots() {
        snapshot("0_CardsOverview")
        app.navigationBars.buttons.allElementsBoundByIndex[1].tap()
        snapshot("1_MoreOverview")
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Calendar"].tap()
        snapshot("2_Calendar")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        tablesQuery.staticTexts["My Lectures"].tap()
        snapshot("3_MyLectures")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        tablesQuery.staticTexts["Study Rooms"].tap()
        snapshot("4_StudyRooms")
//        ToDo: RoomFinder: Wait for callback / results before doing screenshot
//        app.navigationBars["My Lectures"].buttons["More"].tap()
//        tablesQuery.staticTexts["Room Finder"].tap()
//        app.navigationBars["Campus.SearchView"].textFields["Search"].typeText("hs1")
//        snapshot("4_RoomFinderSearch")
        XCTAssert(true)
    }
    
}
