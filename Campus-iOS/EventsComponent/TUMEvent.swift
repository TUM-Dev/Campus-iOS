//
//  TUMEvent.swift
//  Campus-iOS
//
//  Created by Atharva Mathapati on 07.06.23.
//

import Foundation

struct TUMEvent: Codable {
    
    let user, title, category: String
    let date: Date
    let link: String
    let body: String
    let image: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        user = try container.decode(String.self, forKey: .user)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(String.self, forKey: .category)
        link = try container.decode(String.self, forKey: .link)
        body = try container.decode(String.self, forKey: .body)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        let dateString = try container.decode(String.self, forKey: .date)
    
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Invalid date string")
        }
    }
    
    init(user: String, title: String, category: String, date: Date, link: String, body: String, image: String?) {
        self.user = user
        self.title = title
        self.category = category
        self.date = date
        self.link = link
        self.body = body
        self.image = image
    }
}
