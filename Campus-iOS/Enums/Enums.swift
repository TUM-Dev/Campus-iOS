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
    // the year version will not be used as it is too small
    // case year = "Year"
    
    var localizedString: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
    
    var calendarType: CalendarType {
        switch self {
        case .day:
            return CalendarType.day
        case .week:
            return CalendarType.week
        case .month:
            return CalendarType.month
//        case .year:
//            return CalendarType.year
        }
    }
}

enum Gender: Decodable, Hashable {
    case male
    case female
    case nonBinary
    case unkown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        switch try container.decode(String.self) {
        case "M", "m": self = .male
        case "F", "f": self = .female
        default: self = .unkown
        }
    }
}

enum ContactInfo {
    case phone(String)
    case mobilePhone(String)
    case fax(String)
    case additionalInfo(String)
    case homepage(String)

    init?(key: String, value: String) {
        guard !value.isEmpty else { return nil }
        switch key {
        case "telefon": self = .phone(value)
        case "mobiltelefon": self = .mobilePhone(value)
        case "fax": self = .fax(value)
        case "zusatz_info": self = .additionalInfo(value)
        case "www_homepage": self = .homepage(value)
        default: return nil
        }
    }
}

enum Role: String {
    case student = "student"
    case extern = "extern"
    case employee = "employee"

    var localizedDesription: String {
        switch self {
        case .student: return "Student".localized
        case .extern: return "Extern".localized
        case .employee: return "Employee".localized
        }
    }
}
