//
//  StudyRoomAttribute.swift
//  Campus-iOS
//
//  Created by Milen Vitanov on 05.05.22.
//

import Foundation

class StudyRoomAttribute: NSObject, Entity, NSSecureCoding {

    var detail: String?
    var name: String?
    
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(detail, forKey: CodingKeys.detail.rawValue)
        coder.encode(name, forKey: CodingKeys.name.rawValue)
    }
    
    required init?(coder: NSCoder) {
        let detail = coder.decodeObject(of: NSString.self, forKey: CodingKeys.detail.rawValue)
        let name = coder.decodeObject(of: NSString.self, forKey: CodingKeys.name.rawValue)

        self.detail = detail as String?
        self.name = name as String?
    }

    enum CodingKeys: String, CodingKey {
        case detail
        case name
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let detail = try container.decode(String.self, forKey: .detail)
        let name = try container.decode(String.self, forKey: .name)

        self.detail = detail
        self.name = name
    }
}
