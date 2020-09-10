//
//  Movie.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 2/22/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import Foundation
import CoreData

@objc final class Movie: NSManagedObject, Identifiable, Entity {
    @NSManaged public var actors: String?
    @NSManaged public var cover: URL?
    @NSManaged public var created: Date?
    @NSManaged public var date: Date?
    @NSManaged public var director: String?
    @NSManaged public var genre: String?
    @NSManaged public var id: Int64
    @NSManaged public var link: URL?
    @NSManaged public var movieDescription: String?
    @NSManaged public var rating: String?
    @NSManaged public var runtime: String?
    @NSManaged public var title: String?
    @NSManaged public var year: String?
    
    /*
     {
     "kino": "133",
     "date": "2019-04-23 20:00:00",
     "created": "2019-02-07 06:26:03",
     "title": "23. 4. 2019: Drachenzähmen leicht gemacht 3: Die geheime Welt",
     "year": "2019",
     "runtime": "104 min",
     "genre": "Animation, Action, Adventure, Comedy, Family, Fantasy",
     "director": "Dean DeBlois",
     "actors": "Cate Blanchett, Gerard Butler, Kit Harington, Jonah Hill",
     "rating": "8.2",
     "description": "\nJagd auf Drachen? Das finden die Bewohner von Berk ganz und gar nicht lustig. Unter der Führung des jungen Häuptlings Hicks und seines Drachens Ohnezahn versuchen sie die Drachenjäger aufzuhalten. Heroisch überfallen sie die Drachenjäger, befreien\n deren Beute und setzen ihre Schiffe in Brand. Die befreiten Drachen werden eingeladen mit nach Berk zu kommen, wo sie liebevoll umhegt und gepflegt werden. Doch so langsam platzt das Dorf aus allen Nähten … und macht sich gleich\u00adzeitig zur großen Zielscheibe für ambitionierte Drachen\u00adjäger. Schließlich kann man dort aller Sorten Drachen auf einmal fangen.\r\n\r\nDie geschundenen Jäger sind obendrein frustriert von ihren Verlusten und greifen nach dem letzten Strohhalm. Sie holen den Drachenjäger Grimmel aus dem Ruhestand zurück, der eigenhändig alle Nachtschatten erlegt hat, und erzählen ihm von dem einen Exemplar, das er übersehen hat: Ohnezahn. Grimmel hat auch bereits einen Plan, wie er an den letzten Nachtschatten kommen kann. Und durch ihn, den Alpha der Drachen, auch an alle anderen Drachen von Berk.\n",
     "cover": "https://app.tum.de/File/kino/Drachenzhmen leicht gemacht 3 Die geheime Welt.jpg",
     "trailer": null,
     "link": "https://www.tu-film.de/programm/view/1041"
     }
     */
    
    enum CodingKeys: String, CodingKey {
        case actors = "actors"
        case cover = "cover"
        case created = "created"
        case date = "date"
        case director = "director"
        case genre = "genre"
        case id = "kino"
        case link = "link"
        case movieDescription = "description"
        case rating = "rating"
        case runtime = "runtime"
        case title = "title"
        case year = "year"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let actors = try container.decode(String.self, forKey: .actors)
        let coverString = try container.decode(String.self, forKey: .cover)
        guard let cover = URL(string: coverString.replacingOccurrences(of: " ", with: "%20")) else {
            throw DecodingError.typeMismatch(URL.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for cover could not be converted to URL"))
        }
        let created = try container.decode(Date.self, forKey: .created)
        let date = try container.decode(Date.self, forKey: .date)
        let director = try container.decode(String.self, forKey: .director)
        let genre = try container.decode(String.self, forKey: .genre)
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
        }
        let linkString = try container.decode(String.self, forKey: .link)
        guard let link = URL(string: linkString.replacingOccurrences(of: " ", with: "%20")) else {
            throw DecodingError.typeMismatch(URL.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for link could not be converted to URL"))
        }
        let movieDescription = try container.decode(String.self, forKey: .movieDescription)
        let rating = try container.decode(String.self, forKey: .rating)
        let runtime = try container.decode(String.self, forKey: .runtime)
        let title = try container.decode(String.self, forKey: .title)
        let year = try container.decode(String.self, forKey: .year)
        
        self.init(entity: Movie.entity(), insertInto: context)
        self.actors = actors
        self.cover = cover
        self.created = created
        self.date = date
        self.director = director
        self.genre = genre
        self.id = id
        self.link = link
        self.movieDescription = movieDescription
        self.rating = rating
        self.runtime = runtime
        self.title = String(title.split(separator: ":")[1].dropFirst())
        self.year = year
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }
    
}
