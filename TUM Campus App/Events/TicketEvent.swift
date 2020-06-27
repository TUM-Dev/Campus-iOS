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
        case id = "event"
        case eventDescription = "description"
        case file = "file"
        case kinoID = "kino"
        case link = "link"
        case locality = "locality"
        case newsID = "news"
        case start = "start"
        case groupID = "ticket_group"
        case title = "title"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let end = try container.decode(Date.self, forKey: .end)
        let eventString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(eventString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for event could not be converted to Int64"))
        }
        let eventDescription = try container.decode(String.self, forKey: .eventDescription)
        let fileString = try container.decode(String.self, forKey: .file)
        guard let file = URL(string: fileString.replacingOccurrences(of: " ", with: "%20")) else {
            throw DecodingError.typeMismatch(URL.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for file could not be converted to URL"))
        }
        let kinoString = try container.decode(String.self, forKey: .kinoID)
        guard let kinoID = Int64(kinoString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for kino could not be converted to Int64"))
        }
        let linkString = try container.decode(String.self, forKey: .link)
        guard let link = URL(string: linkString.replacingOccurrences(of: " ", with: "%20")) else {
            throw DecodingError.typeMismatch(URL.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for link could not be converted to URL"))
        }
        let locality = try container.decode(String.self, forKey: .locality)
        let newsID = try container.decode(String.self, forKey: .newsID)
        let start = try container.decode(Date.self, forKey: .start)
        let groupID = try container.decode(String.self, forKey: .groupID)
        let title = try container.decode(String.self, forKey: .title)
        
        let movieFetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        movieFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Movie.id), kinoID)
        let movie = try context.fetch(movieFetchRequest).first
        
        self.init(entity: TicketEvent.entity(), insertInto: context)
        self.end = end
        self.id = id
        self.eventDescription = eventDescription
        self.file = file
        self.kinoID = kinoID
        self.link = link
        self.locality = locality
        self.newsID = newsID
        self.start = start
        self.groupID = groupID
        self.title = title
        self.movie = movie
    }
}
