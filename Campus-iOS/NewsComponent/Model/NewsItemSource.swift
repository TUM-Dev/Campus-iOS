//
//  NewsItemSource.swift
//  Campus-iOS
//
//  Created by David Lin on 07.11.22.
//

import Foundation
import CoreData

class NewsItemSource: NSManagedObject, Decodable {
    
    static var all: NSFetchRequest<NewsItemSource> {
        let request = NewsItemSource.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "source"
        case title = "title"
        case icon = "icon"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "NewsItemSource", in: managedObjectContext) else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let idString = try container.decode(String.self, forKey: .id)
        guard let id = Int64(idString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for id could not be converted to Int64"))
        }
        let title = try container.decode(String.self, forKey: .title)
        let iconString = try container.decode(String.self, forKey: .icon)
        let icon = URL(string: iconString.replacingOccurrences(of: " ", with: "%20"))

        self.id = id
        self.title = title
        self.icon = icon
    }
}
