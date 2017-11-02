//
//  SexyEntry.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit
import Fuzzi
import Sweeft

// Very Sexy
struct SexyEntry: DataElement, Codable {
    
    let name: String
    let link: String
    let descriptionText: String
    
    var text: String {
        return name
    }
    
    func getCellIdentifier() -> String {
        return "sexy"
    }
    
}

extension SexyEntry {
    
    func open(sender: UIViewController? = nil) {
        link.url?.open(sender: sender)
    }
    
}

extension SexyEntry {
    
    init?(name: String, json: JSON) {
        guard let link = json["target"].string,
            let descriptionText = json["description"].string else {
                
            return nil
        }
        self.init(name: name, link: link, descriptionText: descriptionText)
    }
    
}

extension SexyEntry: Searchable {
    
    static func == (lhs: SexyEntry, rhs: SexyEntry) -> Bool {
        
        return lhs.name == rhs.name &&
            lhs.link == rhs.link &&
            lhs.descriptionText == rhs.descriptionText
    }
    
    var hashValue: Int {
        return name.hashValue ^ link.hashValue ^ descriptionText.hashValue
    }
    
    var searchableProperties: [KeyPath<SexyEntry, String>] {
        return [
            \.name,
            \.descriptionText,
        ]
    }
    
}
