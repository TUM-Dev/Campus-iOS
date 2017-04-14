//
//  CafeteriaMenu.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
class CafeteriaMenu: DataElement {
    
    let date: Date
    let id: Int
    let name: String
    let typeLong: String
    let typeNr: Int
    let typeShort: String
    let price: Price?
    
    
    init(id: Int, date: Date, typeShort: String, typeLong: String, typeNr: Int, name: String, price: Price?) {
        self.id = id
        self.date = date
        self.typeShort = typeShort
        self.typeLong = typeLong
        self.typeNr = typeNr
        self.name = name
        self.price = price
    }
    
    func getCellIdentifier() -> String {
        return "cafeteriaMenu"
    }
    
    var text: String {
        return name
    }
    
}
