//
//  Plans.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 11.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class Plan: ImageDownloader, DataElement {
    
    let title: String
    let type: String
    let url: String
    let address: String
    let icon: String
    
    init(title: String, type: String, url: String, address: String, icon: String) {
        self.title = title
        self.type = type
        self.url = url
        self.address = address
        self.icon = icon
        super.init()
    }
    
    var text: String {
        get {
            return title
        }
    }
    
    func getCellIdentifier() -> String {
        return "plan"
    }
    
}
