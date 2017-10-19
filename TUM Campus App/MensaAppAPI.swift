//
//  MensaAppAPI.swift
//  Campus
//
//  Created by Mathias Quintero on 10/19/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Sweeft

enum MensaAppEndpoint: String, APIEndpoint {
    case exported = "exportDB.php"
}

struct MensaAppAPI: API {
    
    typealias Endpoint = MensaAppEndpoint
    
    let baseURL: String
    
}
