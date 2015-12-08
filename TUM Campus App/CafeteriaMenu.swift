//
//  CafeteriaMenu.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
class CafeteriaMenu:DataElement {
    
    let cafeteria: Cafeteria
    let date: NSDate
    let id: Int
    let name: String
    let typeLong: String
    let typeNr: Int
    let typeShort: String
    
    init(id: Int, cafeteria: Cafeteria, date: NSDate, typeShort: String, typeLong: String, typeNr: Int, name: String) {
        self.id = id
        self.cafeteria = cafeteria
        self.date = date
        self.typeShort = typeShort
        self.typeLong = typeLong
        self.typeNr = typeNr
        self.name = name
    }
    
    func getCellIdentifier() -> String {
        return "cafeteriaMenu"
    }
    
    var text: String {
        return name
    }
    
}