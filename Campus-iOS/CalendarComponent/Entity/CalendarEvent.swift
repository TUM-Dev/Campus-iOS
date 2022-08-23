//
//  CalendarEvent.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 09.02.22.
//

import Foundation
import KVKCalendar
import UIKit

// XMLDecoder cannot use [Event].self so we have to wrap the events in Calendar.self. This is probably a bug in parsing the root node.
struct CalendarAPIResponse: Decodable {
    var events: [CalendarEvent]?
    
    enum CodingKeys: String, CodingKey {
        case events = "event"
    }
}

struct CalendarEvent: Identifiable, Equatable, Entity {
    var descriptionText: String?
    var endDate: Date?
    var id: Int64
    var location: String?
    var startDate: Date?
    var status: String?
    var title: String?
    var url: URL?
    
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
    
    var kvkEvent: Event {
        var event = Event(ID: self.id.description)
        
        event.start = self.startDate ?? Date()
        event.end = self.endDate ?? Date()
        
        event.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        event.textColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 28/255, green: 171/255, blue: 246/255, alpha: 1)
            default: return UIColor(red: 34/255, green: 126/255, blue: 177/255, alpha: 1)
            }
        }
        
        let secondaryUIColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark: return UIColor(red: 28/255, green: 171/255, blue: 246/255, alpha: 1)
            default: return UIColor(red: 34/255, green: 126/255, blue: 177/255, alpha: 1)
            }
        }
        
        let titleWithTime = (self.title ?? "") + " (\(Self.dateFormatter.string(from: event.start)) - \(Self.dateFormatter.string(from: event.end)))"
        var titleWithTimeAndLocation = titleWithTime
        
        // TODO: attributedTitle in data does not work
        let attributedTitle = NSMutableAttributedString(string: title ?? "").font(.systemFont(ofSize: 12, weight: .bold)).color(event.textColor)
        if let location = self.location {
            titleWithTimeAndLocation += "\n\n\(location)"
            let attributedLocation = NSMutableAttributedString(string: location).font(.systemFont(ofSize: 12, weight: .regular)).color(event.textColor)
            attributedTitle.append(NSAttributedString(string: "\n"))
            attributedTitle.append(attributedLocation)
        }
        
        let textEvent = TextEvent(timeline: titleWithTimeAndLocation, month: "", list: titleWithTime)
        event.title = textEvent
        
        if let description = self.descriptionText {
            let attributedLocation = NSMutableAttributedString(string: description).font(.systemFont(ofSize: 12, weight: .regular)).color(secondaryUIColor)
            attributedTitle.append(NSAttributedString(string: "\n\n"))
            attributedTitle.append(attributedLocation)
        }
        event.data = attributedTitle
        
        return event
    }
    
    var lvNr: String? {
        if let url = self.url?.description, let range = url.range(of: "LvNr=") {
            return String(url[range.upperBound...])
        }
        return nil
    }
    
    init(
        id: Int64,
        status: String? = nil,
        url: URL? = nil,
        title: String? = nil,
        descriptionText:String? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        location: String? = nil) {
            
            self.id = id
            self.status = status
            self.url = url
            self.title = title
            self.descriptionText = descriptionText
            self.startDate = startDate
            self.endDate = endDate
            self.location = location
        }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int64.self, forKey: .id)
        let status = try container.decode(String.self, forKey: .status)
        let url = try container.decodeIfPresent(URL.self, forKey: .url)
        let title = try container.decode(String.self, forKey: .title)
        let descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        let startDate = try container.decode(Date.self, forKey: .startDate)
        let endDate = try container.decode(Date.self, forKey: .endDate)
        let location = try container.decodeIfPresent(String.self, forKey: .location)
        
        self.id = id
        self.status = status
        self.url = url
        self.title = title
        self.descriptionText = descriptionText
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}


class CustomEventDesign: EventViewGeneral {
    override init(style: Style, event: Event, frame: CGRect) {
        super.init(style: style, event: event, frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalendarEvent {
    
    static let mockEvent = CalendarEvent(
        id: 1,
        status: "FT",
        url: URL(string: "https://campus.tum.de/tumonline/lv.detail?cLvNr=950369994"),
        title: "Programmoptimierung (IN2053) VI",
        descriptionText: "fix; Abhaltung; ",
        startDate: Date(),
        endDate: Date().addingTimeInterval(60 * 60),
        location: "00.13.009A, Seminarraum (5613.EG.009A)"
    )
}
