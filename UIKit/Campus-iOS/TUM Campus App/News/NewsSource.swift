//
//  NewsSource.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/2/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import CoreData


@objc final class NewsSource: NSManagedObject, Entity {
    @NSManaged public var icon: URL?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var news: NSSet?

    @objc(addNewsObject:)
    @NSManaged public func addToNews(_ value: News)

    @objc(removeNewsObject:)
    @NSManaged public func removeFromNews(_ value: News)

    @objc(addNews:)
    @NSManaged public func addToNews(_ values: NSSet)

    @objc(removeNews:)
    @NSManaged public func removeFromNews(_ values: NSSet)
    
    enum CodingKeys: String, CodingKey {
        case id = "source"
        case title = "title"
        case icon = "icon"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError() }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
        }
        let title = try container.decode(String.self, forKey: .title)
        let iconString = try container.decode(String.self, forKey: .icon)
        let icon = URL(string: iconString.replacingOccurrences(of: " ", with: "%20"))
        
        let newsFetchRequest: NSFetchRequest<News> = News.fetchRequest()
        newsFetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(News.sourceID) , id)
        let news = try context.fetch(newsFetchRequest)
        
        self.init(entity: NewsSource.entity(), insertInto: context)
        self.id = id
        self.title = title
        self.icon = icon
        self.news = NSSet(array: news)
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsSource> {
        return NSFetchRequest<NewsSource>(entityName: "NewsSource")
    }
    
}
