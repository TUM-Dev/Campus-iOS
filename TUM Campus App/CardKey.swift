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
    //case bookRental
    case mvg
    case grades
    case studyRooms
    case lectures
    
    var description: String {
        switch self {
        case .tufilm:
            return "TU Film"
        case .calendar:
            return "Calendar"
        case .cafeteria:
            return "Cafeteria"
        case .news:
            return "News"
        case .newsspread:
            return "Newsspread"
        case .tuition:
            return "Tuition"
        /*
        case .bookRental:
            return "Book Rental"
        */
        case .mvg:
            return "MVG"
        case .grades:
            return "Grades"
        case .studyRooms:
            return "Study Rooms"
        case .lectures:
            return "Lectures"
        }
    }
    
    static var all: [CardKey] = [.tufilm, .calendar, .news, .cafeteria, .tuition,
                                 /*.bookRental,*/ .mvg, .grades, .studyRooms, .lectures, .newsspread]
    
}
