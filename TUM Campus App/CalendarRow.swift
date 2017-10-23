//
//  CalendarRow.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft
import SWXMLHash
import CoreLocation

final class CalendarRow: DataElement {
    var description: String?
    var dtend: Date?
    var dtstart: Date?
    var geo: CLLocation?
    var location: String?
    var status: String?
    var title: String?
    var url: URL?
    
    func getCellIdentifier() -> String {
        return "calendarRow"
    }
    
    var text: String {
        return title?.components(separatedBy: " (")[0].components(separatedBy: " [")[0] ?? ""
    }
    
}

extension CalendarRow: XMLDeserializable {
    
    convenience init?(from xml: XMLIndexer) {
        guard let title = xml["title"].element?.text,
            let start = xml["dtstart"].element?.text.date(using: "yyyy-MM-dd HH:mm:ss"),
            let end = xml["dtend"].element?.text.date(using: "yyyy-MM-dd HH:mm:ss"),
            let status = xml["status"].element?.text,
            let link = xml["url"].element?.text else {
                
                return nil
        }
        self.init()
        self.title = title
        self.dtstart = start
        self.dtend = end
        self.status = status
        self.url = URL(string: link)
    }
    
}
