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
struct CalendarAPIResponse: Decodable {
    var events: [CalendarEvent]?
    
    enum CodingKeys: String, CodingKey {
        case events = "event"
    }
}

@objc final class CalendarEvent: NSManagedObject, Identifiable, Entity {
    @NSManaged public var descriptionText: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var location: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?

    
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

    enum CodingKeys: String, CodingKey {
        case descriptionText = "description"
        case startDate = "dtstart"
        case endDate = "dtend"
        case location = "location"
        case id = "nr"
        case status = "status"
        case title = "title"
        case url = "url"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int64.self, forKey: .id)
        let status = try container.decode(String.self, forKey: .status)
        let url = try container.decodeIfPresent(URL.self, forKey: .url)
        let title = try container.decode(String.self, forKey: .title)
        let descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        let startDate = try container.decode(Date.self, forKey: .startDate)
        let endDate = try container.decode(Date.self, forKey: .endDate)
        let location = try container.decodeIfPresent(String.self, forKey: .location)
        
        self.init(entity: CalendarEvent.entity(), insertInto: context)
        self.id = id
        self.status = status
        self.url = url
        self.title = title
        self.descriptionText = descriptionText
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalendarEvent> {
        return NSFetchRequest<CalendarEvent>(entityName: "CalendarEvent")
    }
    
}
