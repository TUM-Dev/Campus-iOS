//
//  SexyEntry.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 3/28/17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

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
    
    func open() {
        guard let url = URL(string: link) else {
            return
        }
        UIApplication.shared.open(url)
    }
    
}
