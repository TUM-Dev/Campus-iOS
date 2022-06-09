//
//  StudyRoomAttribute.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation

struct StudyRoomAttribute: Entity {
    var detail: String?
    var name: String?

    enum CodingKeys: String, CodingKey {
        case detail
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)

        self.detail = detail
        self.name = name
    }
}
