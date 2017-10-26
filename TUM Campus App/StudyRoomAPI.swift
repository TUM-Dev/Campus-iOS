//
//  StudyRoomAPI.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 5/1/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

enum StudyRoomEndpoint: String, APIEndpoint {
    case rooms = "ris_api.php"
}

struct StudyRoomAPI: API {
    
    typealias Endpoint = StudyRoomEndpoint
    
    let baseURL: String
    
    var baseQueries: [String : String] {
        return [
            "format": "json"
        ]
    }
    
}
