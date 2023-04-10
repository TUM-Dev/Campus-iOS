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

enum ContactInfo: Identifiable {
    var id: String {
        switch self {
        case .phone(let phone):
            return phone
        case .mobilePhone(let mobile):
            return mobile
        case .fax(let fax):
            return fax
        case .additionalInfo(let info):
            return info
        case .homepage(let homepage):
            return homepage
        }
    }
    
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

/* Views for which we gather usage data for the widget recommendations. */
enum CampusAppView: String, CaseIterable {
    case cafeteria = "cafeteria",
         cafeterias = "cafeterias",
         calendar = "calendar",
         calendarEvent = "calendarEvent",
         grades = "grades",
         studyRoom = "studyRoom",
         studyRooms = "studyRooms",
         tuition = "tuition"
    
    // Widgets associated to the widget in some way.
    // We can use this to make assumptions for widget recommendations, based on the views that the user visited.
    func associatedWidget() -> Widget {
        switch self {
        case .cafeteria:
            return .cafeteria
        case .cafeterias:
            return .cafeteria
        case .calendar:
            return .calendar
        case .calendarEvent:
            return .calendar
        case .grades:
            return .grades
        case .studyRoom:
            return .studyRoom
        case .studyRooms:
            return .studyRoom
        case .tuition:
            return .tuition
        }
    }
}
