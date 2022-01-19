//
//  News.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 19.01.22.
//

import Foundation


struct News: Entity {
    var id: String?
    var sourceID: Int64
    var date: Date?
    var created: Date?
    var title: String?
    var link: URL?
    var imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case id = "news"
        case sourceID = "src"
        case date = "date"
        case created = "created"
        case title = "title"
        case link = "link"
        case imageURL = "image"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(String.self, forKey: .id)
        let sourceString = try container.decode(String.self, forKey: .sourceID)
        guard let sourceID = Int64(sourceString) else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value for source could not be converted to Int64"))
        }
        let date = try container.decode(Date.self, forKey: .date)
        let created = try container.decode(Date.self, forKey: .created)
        let title = try container.decode(String.self, forKey: .title)
        let link = try container.decode(URL.self, forKey: .link)
        let imageURLString = try container.decode(String.self, forKey: .imageURL)
        let imageURL = URL(string: imageURLString.replacingOccurrences(of: " ", with: "%20"))

        self.id = id
        self.sourceID = sourceID
        self.date = date
        self.created = created
        self.title = title
        self.link = link
        self.imageURL = imageURL
    }
}
