//
//  SexyEntry.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
