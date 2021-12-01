//
//  News.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/4/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData

@objc final class News: NSManagedObject, Identifiable, Entity {
    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var imageURL: URL?
    @NSManaged public var link: URL?
    @NSManaged public var sourceID: Int64
    @NSManaged public var title: String?
    @NSManaged public var source: NewsSource?

    
    /*
     "news": "513322",
     "src": "2",
     "date": "2019-02-05 20:00:00",
     "created": "2018-09-10 05:41:03",
     "title": "5. 2. 2019: Der Schuh des Manitu",
     "link": "https://www.tu-film.de/programm/view/1039",
     "image": "https://app.tum.de/File/news/newspread/ce274425d460c28ded9ed9a4ab525de9.jpg"
     */
    
    enum CodingKeys: String, CodingKey {
        case id = "news"
        case sourceID = "src"
        case date = "date"
        case title = "title"
        case link = "link"
        case imageURL = "image"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let sourceString = try container.decode(String.self, forKey: .sourceID)
        guard let sourceID = Int64(sourceString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for source could not be converted to Int64"))
        }
        let date = try container.decode(Date.self, forKey: .date)
        let title = try container.decode(String.self, forKey: .title)
        let link = try container.decode(URL.self, forKey: .link)
        let imageURLString = try container.decode(String.self, forKey: .imageURL)
        let imageURL = URL(string: imageURLString.replacingOccurrences(of: " ", with: "%20"))
        
        let sourceFetchRequest: NSFetchRequest<NewsSource> = NewsSource.fetchRequest()
        sourceFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(NewsSource.id) , sourceID)
        let source = try context.fetch(sourceFetchRequest).first
        
        self.init(entity: News.entity(), insertInto: context)
        self.id = id
        self.sourceID = sourceID
        self.date = date
        self.title = title
        self.link = link
        self.imageURL = imageURL
        self.source = source
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }
    
}
