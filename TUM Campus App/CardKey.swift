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
    case cafeteria
    case tuition
    case bookRental
    
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
        case .tuition:
            return "Tuition"
        case .bookRental:
            return "Book Rental"
        }
    }
    
    static var all: [CardKey] = [.tufilm, .calendar, .news, .cafeteria, .tuition, .bookRental,]
    
}
