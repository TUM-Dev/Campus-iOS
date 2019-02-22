//
//  Event.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/15/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData

// XMLDecoder cannot use [Event].self so we have to wrap the events in Calendar.self. This is probably a bug in parsing the root node.
struct Calendar: Decodable {
    var events: [Event]
    
    enum CodingKeys: String, CodingKey {
        case events = "event"
    }
}

@objc class Event: NSManagedObject, Entity {
    
/*
     <event>
        <nr>886515989</nr>
        <status>FT</status>
        <url>https://campus.tum.de/tumonline/lv.detail?cLvNr=950369994</url>
        <title>Programmoptimierung (IN2053) VI</title>
        <description>fix; Abhaltung; </description>
        <dtstart>2019-01-16 10:00:00</dtstart>
        <dtend>2019-01-16 12:00:00</dtend>
        <location>00.13.009A, Seminarraum (5613.EG.009A)</location>
     </event>
*/

/*
    @NSManaged public var descriptionText: String?
    @NSManaged public var dtstart: Date?
    @NSManaged public var dtend: Date?
    @NSManaged public var location: String?
    @NSManaged public var nr: Int64
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
 */
    
    enum CodingKeys: String, CodingKey {
        case descriptionText = "description"
        case dtstart = "dtstart"
        case dtend = "dtend"
        case location = "location"
        case nr = "nr"
        case status = "status"
        case title = "title"
        case url = "url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let nr = try container.decode(Int64.self, forKey: .nr)
        let status = try container.decode(String.self, forKey: .status)
        let url = try container.decode(String.self, forKey: .url)   // TODO: use URL instead of String
        let title = try container.decode(String.self, forKey: .title)
        let descriptionText = try container.decode(String.self, forKey: .descriptionText)
        let dtstart = try container.decode(Date.self, forKey: .dtstart)
        let dtend = try container.decode(Date.self, forKey: .dtend)
        let location = try container.decode(String.self, forKey: .location)
        
        self.init(entity: Event.entity(), insertInto: context)
        self.nr = nr
        self.status = status
        self.url = url
        self.title = title
        self.descriptionText = descriptionText
        self.dtstart = dtstart
        self.dtend = dtend
        self.location = location
    }
    
}
