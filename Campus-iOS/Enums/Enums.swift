//
//  Enums.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 13.01.22.
//

import Foundation
import KVKCalendar

enum SheetDestination {
    case none
    case loginSheet(model: Model)
    case profileSheet(model: Model)
}

enum TumCalendarTypes: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var calendarType: CalendarType {
        switch(self) {
        case .day:
            return CalendarType.day
        case .week:
            return CalendarType.week
        case .month:
            return CalendarType.month
        case .year:
            return CalendarType.year
        }
    }
}

enum TumSexyCodingKeys: String, CodingKey {
    case linkDescription = "description"
    case moodleID = "moodle_id"
    case target = "target"
}
