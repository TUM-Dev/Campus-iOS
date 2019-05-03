//
//  CardKey.swift
//  TUM Campus App
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

import Foundation

enum CardKey: Int, Codable {
    case tufilm
    case calendar
    case news
    case newsspread
    case cafeteria
    case tuition
    case mvg
    case grades
    case studyRooms
    case lectures
    
    var description: String {
        switch self {
        case .tufilm:
            return NSLocalizedString("TU Film", comment: "")
        case .calendar:
            return NSLocalizedString("Calendar", comment: "")
        case .cafeteria:
            return NSLocalizedString("Cafeteria", comment: "")
        case .news:
            return NSLocalizedString("News", comment: "")
        case .newsspread:
            return NSLocalizedString("Newsspread", comment: "")
        case .tuition:
            return NSLocalizedString("Tuition", comment: "")
        case .mvg:
            return NSLocalizedString("MVG", comment: "")
        case .grades:
            return NSLocalizedString("Grades", comment: "")
        case .studyRooms:
            return NSLocalizedString("Study Rooms", comment: "")
        case .lectures:
            return NSLocalizedString("Lectures", comment: "")
        }
    }
    
    static var all: [CardKey] = [.tufilm, .calendar, .news, .cafeteria, .tuition,
                                 .mvg, .grades, .studyRooms, .lectures, .newsspread]
    
}
