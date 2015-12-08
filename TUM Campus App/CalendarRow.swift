//
//  CalendarRow.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import CoreLocation
class CalendarRow: DataElement, Equatable, Hashable {
    var description: String?
    var dtend: NSDate?
    var dtstart: NSDate?
    var geo: CLLocation?
    var location: String?
    var status: String?
    var title: String?
    var url: NSURL?
    
    func getCellIdentifier() -> String {
        return "calendarRow"
    }
    
    var hashValue: Int {
        return dtstart?.hashValue ?? 0 * 10 + (dtend?.hashValue ?? 0)
    }
    
}

func == (lhs: CalendarRow, rhs: CalendarRow) -> Bool {
    return lhs.title == rhs.title && lhs.dtstart == rhs.dtstart
}