//
//  SearchResultKey.swift
//  Campus
//
//  Created by Mathias Quintero on 10/26/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation

struct SearchResults {
    let key: SearchResultKey
    let results: [DataElement]
}

enum SearchResultKey: Int, Codable {
    case room
    case lecture
    case person
    case sexy
}

extension SearchResultKey {
    
    var description: String {
        switch self {
        case .room:
            return "Rooms"
        case .lecture:
            return "Lecture"
        case .person:
            return "People"
        case .sexy:
            return "TUM Sexy"
        }
    }
    
}
