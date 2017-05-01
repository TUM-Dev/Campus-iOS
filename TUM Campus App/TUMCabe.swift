//
//  TUMCabe.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 4/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

enum TUMCabeEndpoint: String, APIEndpoint {
    case movie = "kino/"
    case cafeteria = "mensen/"
    case news = "news/"
}

struct TUMCabeAPI: API {
    
    typealias Endpoint = TUMCabeEndpoint
    
    let baseURL: String
    
    var baseHeaders: [String : String] {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString,
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            
            return .empty
        }
        return [
            "X-DEVICE-ID": uuid,
            "X-APP-VERSION": appVersion,
            "X-OS-VERSION": UIDevice.current.systemVersion,
        ]
    }
    
}
