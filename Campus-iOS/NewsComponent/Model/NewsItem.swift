//
//  NewsItem.swift
//  Campus-iOS
//
//  Created by David Lin on 07.11.22.
//

import Foundation
import CoreData

class NewsItem: NSManagedObject & Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "news"
        case sourceID = "src"
        case date = "date"
        case created = "created"
        case title = "title"
        case link = "link"
        case imageURL = "image"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
//              let source = decoder.userInfo[CodingUserInfoKey.newsItemSource] as? NewsItemSource,
                let entity = NSEntityDescription.entity(forEntityName: "NewsItem", in: managedObjectContext) else {
              throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        let sourceString = try container.decode(String.self, forKey: .sourceID)
        guard let decodedSourceID = Int64(sourceString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for source could not be converted to Int64"))
        }
        self.sourceID = decodedSourceID
        self.date = try container.decode(Date.self, forKey: .date)
        self.created = try container.decode(Date.self, forKey: .created)
        self.title = try container.decode(String.self, forKey: .title)
        
        // Since "" is in JSON a valid String, but nil is not a valid URL to be decoded a special treatment is nedded
        let linkString = try container.decode(String.self, forKey: .link)
        
        self.link = URL(string: linkString)
        
        
        let imageURLString = try container.decode(String.self, forKey: .imageURL)
        self.imageURL =  URL(string: imageURLString)
        
//        self.newsItemSource = source
    }
    
}
