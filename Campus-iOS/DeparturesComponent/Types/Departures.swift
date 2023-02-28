//
//  Departures.swift
//  Campus-iOS
//
//  Created by Jakob Paul Körber on 28.02.23.
//

import Foundation
import SwiftUI
import CoreLocation

// MARK: - General Request
struct MVVRequest: Codable {
    let requestDateTime: RequestDateTime
    let departures: [Departure]
    
    enum CodingKeys: String, CodingKey {
        case requestDateTime = "dateTime"
        case departures = "departureList"
    }
}

// MARK: - Time of Request
struct RequestDateTime: Codable {
    let deparr, ttpFrom, ttpTo, year: String
    let month, day, hour, minute: String
}

// MARK: - Departures at given location
struct Departure: Codable, Hashable {
    let stopID, countdown: Int
    let dateTime: DepartureDateTime
    let realDateTime: DepartureDateTime?
    let servingLine: ServingLine
    let lineInfos: LineInfos?
    
    init(stopID: Int, countdown: Int, dateTime: DepartureDateTime, realDateTime: DepartureDateTime?, servingLine: ServingLine, lineInfos: LineInfos?) {
        self.stopID = stopID
        self.countdown = countdown
        self.dateTime = dateTime
        self.realDateTime = realDateTime
        self.servingLine = servingLine
        self.lineInfos = lineInfos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stopID = Int(try container.decode(String.self, forKey: .stopID)) ?? 0
        self.countdown = Int(try container.decode(String.self, forKey: .countdown)) ?? 0
        self.dateTime = try container.decode(DepartureDateTime.self, forKey: .dateTime)
        self.realDateTime = try container.decodeIfPresent(DepartureDateTime.self, forKey: .realDateTime)
        self.servingLine = try container.decode(ServingLine.self, forKey: .servingLine)
        self.lineInfos = try container.decodeIfPresent(LineInfos.self, forKey: .lineInfos)
    }
}

struct DepartureDateTime: Codable, Hashable {
    let year, month, day, weekday, hour, minute: Int
    
    init(year: Int, month: Int, day: Int, weekday: Int, hour: Int, minute: Int) {
        self.year = year
        self.month = month
        self.day = day
        self.weekday = weekday
        self.hour = hour
        self.minute = minute
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.year = Int(try container.decode(String.self, forKey: .year)) ?? 0
        self.month = Int(try container.decode(String.self, forKey: .month)) ?? 0
        self.day = Int(try container.decode(String.self, forKey: .day)) ?? 0
        self.weekday = Int(try container.decode(String.self, forKey: .weekday)) ?? 0
        self.hour = Int(try container.decode(String.self, forKey: .hour)) ?? 0
        self.minute = Int(try container.decode(String.self, forKey: .minute)) ?? 0
    }
}

struct ServingLine: Codable, Hashable {
    let key, code: Int
    let number, symbol: String
    let delay: Int?
    let direction, name: String
    
    
    init(key: Int, code: Int, number: String, symbol: String, delay: Int?, direction: String, name: String) {
        self.key = key
        self.code = code
        self.number = number
        self.symbol = symbol
        self.delay = delay
        self.direction = direction
        self.name = name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.key = Int(try container.decode(String.self, forKey: .key)) ?? 0
        self.code = Int(try container.decode(String.self, forKey: .code)) ?? 0
        self.number = try container.decode(String.self, forKey: .number)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.delay = Int(try container.decodeIfPresent(String.self, forKey: .delay) ?? "") ?? 0
        self.direction = try container.decode(String.self, forKey: .direction)
        self.name = try container.decode(String.self, forKey: .name)
    }
    
    func mapColor() -> Color {
        if self.code == 3 { /// busses
            return Color(red: 1 / 255, green: 83 / 255, blue: 102 / 255)
        } else if self.code == 1 { /// metro
            switch number {
            case "U2": return Color(red: 194 / 255, green: 08 / 255, blue: 49 / 255)
            case "U4": return Color(red: 3 / 255, green: 169 / 255, blue: 132 / 255)
            case "U5": return Color(red: 188 / 255, green: 122 / 255, blue: 0 / 255)
            case "U6": return Color(red: 0 / 255, green: 114 / 255, blue: 179 / 255)
            default: return Color.gray
            }
        } else if self.code == 4 { /// tram
            return Color(red: 226 / 255, green: 7 / 255, blue: 18 / 255)
        } else { /// not assigned
            return Color.gray
        }
    }
}

struct LineInfos: Hashable, Codable {
    let lineInfo: LineInfo
}

struct LineInfo: Hashable, Codable {
    let infoLinkText: String?
    let infoText: InfoText?
    let additionalLinks: [AdditionalLink]?
}

struct AdditionalLink: Hashable, Codable {
    let id: String
    let linkURL: String
    let linkText, linkTextShort, linkTarget: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case linkURL, linkText, linkTextShort, linkTarget
    }
}

struct InfoText: Hashable, Codable {
    let content, subtitle: String
}

// MARK: - local types
struct Station: Hashable, Codable {
    let name: String
    let apiName: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}
