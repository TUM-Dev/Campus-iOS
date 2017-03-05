//
//  TUM_Campus_AppUITests.swift
//  TUM Campus AppUITests
//
//  Created by Mathias Quintero on 10/28/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import XCTest

class TUM_Campus_AppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        sleep(10)

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMoreToCalendarStartsAtTheCurrentDate() {
        let app = XCUIApplication()
        sleep(60)
        app.tabBars.buttons["More"].tap()
        sleep(10)
        app.tables.staticTexts["Calendar"].tap()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        let dateFormatted = formatter.string(from: date)
        
        print("The current date is \(dateFormatted)")
        
        XCTAssert(app.navigationBars[dateFormatted].exists)
    }
    
}
