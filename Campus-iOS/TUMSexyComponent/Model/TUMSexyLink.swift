//
//  TUMSexyLink.swift
//  Campus-iOS
//
//  Created by David Lin on 23.01.23.
//

import Foundation

struct TUMSexyLink: Decodable, Identifiable {
    var id = UUID()
    var description: String?
    var target: String?
    var moodleID: String?
    
    enum CodingKeys: String, CodingKey {
        case description = "description"
        case target = "target"
        case moodleID = "moodleID"
    }
}
