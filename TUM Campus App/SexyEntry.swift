//
//  SexyEntry.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft

// Very Sexy
struct SexyEntry: DataElement {
    
    let name: String
    let link: String
    let descriptionText: String
    
    var text: String {
        return name
    }
    
    func getCellIdentifier() -> String {
        return ""
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
