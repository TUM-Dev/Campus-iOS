//
//  TUM_Campus_AppUITests.swift
//  TUM Campus AppUITests
//
//  Created by Tim Gymnich on 12/30/18.
//  Copyright © 2018 TUM. All rights reserved.
//

import XCTest

class TUM_Campus_AppUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        app.launchEnvironment = ProcessInfo.processInfo.environment
        app.launchArguments = ProcessInfo.processInfo.arguments
        app.launch()


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCalendar() {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Calendar"].tap()

        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["10"].tap()
        elementsQuery.buttons["9"].tap()
        elementsQuery.buttons["8"].tap()

        let calendarNavigationBar = app.navigationBars["Calendar"]
        calendarNavigationBar.buttons["Today"].tap()
        calendarNavigationBar.children(matching: .button).matching(identifier: "Profile").element(boundBy: 0).tap()
        app.navigationBars["Events"].buttons["Calendar"].tap()

    }

    func testLectures() {
        XCUIApplication().tabBars["Tab Bar"].buttons["Lectures"].tap()
    }

    func testGrades() {
        XCUIApplication().tabBars["Tab Bar"].buttons["Grades"].tap()
    }

    func testCafeteria() {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Cafeterias"].tap()
        app.alerts["Allow “Campus App” to use your location?"].scrollViews.otherElements.buttons["Allow While Using App"].tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Mensa Arcisstraße"]/*[[".cells.staticTexts[\"Mensa Arcisstraße\"]",".staticTexts[\"Mensa Arcisstraße\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Mensa Arcisstraße"].buttons["Cafeterias"].tap()
    }

    func testStudyRooms() {
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["Study Rooms"].tap()
        XCUIApplication().navigationBars["StudiTUM Innenstadt"].buttons["Study Rooms"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["StudiTUM Innenstadt"]/*[[".cells.staticTexts[\"StudiTUM Innenstadt\"]",".staticTexts[\"StudiTUM Innenstadt\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    func testProfile() {
        let app = XCUIApplication()
        app.navigationBars["Study Rooms"].buttons["Profile"].tap()
    }

    func testRoomFinder() {
        let app = XCUIApplication()
        app.navigationBars["Study Rooms"].buttons["Profile"].tap()

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Room Finder"]/*[[".cells.staticTexts[\"Room Finder\"]",".staticTexts[\"Room Finder\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let roomFinderNavigationBar = app.navigationBars["Room Finder"]
        roomFinderNavigationBar.searchFields["Search Rooms"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hörsaal"]/*[[".cells.staticTexts[\"Hörsaal\"]",".staticTexts[\"Hörsaal\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        app/*@START_MENU_TOKEN@*/.buttons["chevron.down.circle.fill"]/*[[".scrollViews.buttons[\"chevron.down.circle.fill\"]",".buttons[\"chevron.down.circle.fill\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["5510.EG.001"].buttons["Room Finder"].tap()
        roomFinderNavigationBar.buttons["Cancel"].tap()
    }

    func testTUMSexy() {
        let app = XCUIApplication()
        app.navigationBars["Study Rooms"].buttons["Profile"].tap()

        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["TUM.sexy"]/*[[".cells.staticTexts[\"TUM.sexy\"]",".staticTexts[\"TUM.sexy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.staticTexts["eat-api output in a human readable format as well as the base url for eat-api calls"].tap()
    }

    func testNews() {

        let app = XCUIApplication()
        app.navigationBars["Calendar"].children(matching: .button).matching(identifier: "Profile").element(boundBy: 1).tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["News"]/*[[".cells.staticTexts[\"News\"]",".staticTexts[\"News\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .scrollView).element(boundBy: 0).children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app.navigationBars["TUMCampusApp.MovieDetailCollectionView"].buttons["News"].tap()
        collectionViewsQuery.children(matching: .scrollView).element(boundBy: 1).children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
    }

}
