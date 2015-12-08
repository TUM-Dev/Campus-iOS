//
//  CalendarRow.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import CoreLocation
class CalendarRow: DataElement {
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
    
    var text: String {
        return title ?? ""
    }
    
}