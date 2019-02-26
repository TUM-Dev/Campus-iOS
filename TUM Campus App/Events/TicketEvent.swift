//
//  TicketEvent.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/24/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class TicketEvent: NSManagedObject, Entity {
    
    /*
     {
        "event": "1",
        "news": "513304",
        "kino": "113",
        "file": "https://app.tum.de/File/events/ArthurClaire.jpg",
        "title": "Arthur & Claire (#TUM4MIND, ÖV)",
        "description": "Wenn ein unheilbar an Lungenkrebs erkrankter Mann am Vorabend seines geplanten Suizids in einer     Sterbehilfeklinik auf eine junge Frau trifft, die meint, alles verloren zu haben, stellt sich die Frage nach dem Sinn   des Lebens ganz unmittelbar.",
        "locality": "Arcisstraße 21, 80333",
        "link": "https://tu-film.de/programm/view/1018",
        "start": "2018-11-06 20:00:00",
        "end": "2018-11-06 23:00:00",
        "ticket_group": "1"
     },
 */
    
    enum CodingKeys: String, CodingKey {
        case end = "end"
        case event = "event"
        case event_description = "description"
        case file = "file"
        case kino = "kino"
        case link = "link"
        case locality = "locality"
        case news_id = "news"
        case start = "start"
        case ticket_group = "ticket_group"
        case title = "title"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let end = try container.decode(String.self, forKey: .end)
        let eventString = try container.decode(String.self, forKey: .event)
        guard let event = Int64(eventString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for event could not be converted to Int64"))
        }
        let event_description = try container.decode(String.self, forKey: .event_description)
        let file = try container.decode(String.self, forKey: .file)
        let kino = try container.decode(String.self, forKey: .kino)
        let link = try container.decode(String.self, forKey: .link)
        let locality = try container.decode(String.self, forKey: .locality)
        let news_id = try container.decode(String.self, forKey: .news_id)
        let start = try container.decode(String.self, forKey: .start)
        let ticket_group = try container.decode(String.self, forKey: .ticket_group)
        let title = try container.decode(String.self, forKey: .title)
        
        let movieFetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        movieFetchRequest.predicate = NSPredicate(format: "\(Movie.CodingKeys.kino.rawValue) == %@", kino)
        let movie = try context.fetch(movieFetchRequest).first
        
        self.init(entity: TicketEvent.entity(), insertInto: context)
        self.end = end
        self.event = event
        self.event_description = event_description
        self.file = file
        self.kino = kino
        self.link = link
        self.locality = locality
        self.news_id = news_id
        self.start = start
        self.ticket_group = ticket_group
        self.title = title
        self.movie = movie
    }
}
