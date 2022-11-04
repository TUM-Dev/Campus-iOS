//
//  CalendarWidget_Tests.swift
//  Campus-iOSTests
//
//  Created by Robyn Kölle on 04.11.22.
//

import XCTest
@testable import Campus_iOS

final class CalendarWidget_Tests: XCTestCase {
    
    // 04 November 2022, 11 a.m. (GMT+1)
    static let today = Date(timeIntervalSince1970: 1667556000)
    
    // 04 November 2022, 10 p.m. (GMT+1)
    static let dateAfterTodaysEvents = Date(timeIntervalSince1970: 1667595600)
    
    static let eventLaterToday1 = CalendarEvent(id: 1, startDate: today.addingTimeInterval(60 * 60 * 3), endDate: today.addingTimeInterval(60 * 60 * 4))
    static let eventLaterToday2 = CalendarEvent(id: 2, startDate: today.addingTimeInterval(60 * 60 * 5), endDate: today.addingTimeInterval(60 * 60 * 6))
    static let eventTomorrow1 = CalendarEvent(id: 3, startDate: today.addingTimeInterval(60 * 60 * 24), endDate: today.addingTimeInterval(60 * 60 * 24 + 60 * 60))
    static let eventTomorrow2 = CalendarEvent(id: 4, startDate: today.addingTimeInterval(60 * 60 * 24 + 60 * 60 * 2), endDate: today.addingTimeInterval(60 * 60 * 24 + 60 * 60 * 3))
    
    let allEvents = [eventLaterToday1, eventLaterToday2, eventTomorrow1, eventTomorrow2]
    let eventsToday = [eventLaterToday1, eventLaterToday2]
    let eventsTomorrow = [eventTomorrow1, eventTomorrow2]

    func testDisplayTodaysEvents() async throws {
        let viewModel = await CalendarWidgetViewModel(events: allEvents)
        let upcomingEvents = await viewModel.upcomingEvents(now: CalendarWidget_Tests.today)
        XCTAssertEqual(upcomingEvents, eventsToday)
    }
    
    func testDisplayTomorrowsEvents() async throws {
        let viewModel = await CalendarWidgetViewModel(events: allEvents)
        let upcomingEvents = await viewModel.upcomingEvents(now: CalendarWidget_Tests.dateAfterTodaysEvents)
        XCTAssertEqual(upcomingEvents, eventsTomorrow)
    }

}
