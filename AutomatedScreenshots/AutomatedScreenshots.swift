//
//  AutomatedScreenshots.swift
//  AutomatedScreenshots
//
//  Created by Max Muth on 09.03.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
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
        app.tabBars.buttons["More"].tap()
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
