//
//  CardKey.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import Foundation

enum CardKey: Int, Codable {
    case tufilm
    case calendar
    case news
    case newsspread
    case cafeteria
    case tuition
    case bookRental
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
        case .bookRental:
            return "Book Rental"
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
    
    static var all: [CardKey] = [.tufilm, .calendar, .news, .cafeteria, .tuition, .bookRental, .mvg, .grades, .studyRooms, .lectures, .newsspread]
    
}
