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
