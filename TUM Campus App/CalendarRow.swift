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
    
    var start: Date
    var end: Date
    
    var title: String
    var description: String?
    var status: String
    
    var geo: CLLocation?
    var location: String?
    var url: URL?
    
    init(start: Date,
         end: Date,
         title: String,
         description: String?,
         status: String,
         geo: CLLocation? = nil,
         location: String?,
         url: URL?) {
        
        self.start = start
        self.end = end
        self.title = title
        self.description = description
        self.status = status
        self.geo = geo
        self.location = location
        self.url = url
    }
    
    func getCellIdentifier() -> String {
        return "calendarRow"
    }
    
    var text: String {
        return title.components(separatedBy: " (")[0].components(separatedBy: " [")[0]
    }
    
    var lectureId: String? {
        let components = url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
        return components?.queryItems?.first(where: \.name, equals: "cLvNr")?.value
    }
    
    func open(sender: UIViewController? = nil) {
        url?.open(sender: sender)
    }
    
}

extension CalendarRow: XMLDeserializable {
    
    convenience init?(from xml: XMLIndexer) {
        
        guard let title = xml["title"].element?.text,
            let start = xml["dtstart"].element?.text.date(using: "yyyy-MM-dd HH:mm:ss"),
            let end = xml["dtend"].element?.text.date(using: "yyyy-MM-dd HH:mm:ss"),
            let status = xml["status"].element?.text else {
                
                return nil
        }
        self.init(start: start,
                  end: end,
                  title: title,
                  description: xml["description"].element?.text,
                  status: status,
                  location: xml["location"].element?.text,
                  url: xml["url"].element?.text.url)
    }
    
}
