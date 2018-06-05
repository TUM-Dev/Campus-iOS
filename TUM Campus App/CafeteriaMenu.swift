//
//  CafeteriaMenu.swift
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

import Sweeft

class CafeteriaMenu: DataElement {
    
    let date: Date
    let id: String?
    let name: String
    let typeLong: String
    let typeNr: String?
    let typeShort: String
    let price: Price?
    let details: MenuDetail
    let mensaId: String
    
    
    init(id: String?,
         date: Date,
         typeShort: String,
         typeLong: String,
         typeNr: String?,
         name: String,
         price: Price?,
         details: MenuDetail,
         mensaId: String) {
        
        self.id = id
        self.date = date
        self.typeShort = typeShort
        self.typeLong = typeLong
        self.typeNr = typeNr
        self.name = name
        self.price = price
        self.details = details
        self.mensaId = mensaId
    }
    
    func getCellIdentifier() -> String {
        return "cafeteriaMenu"
    }
    
    var text: String {
        return name
    }
    
}

extension CafeteriaMenu {
    
    convenience init?(from json: JSON) {
        guard let mensaId = json["mensa_id"].string,
            let date = json["date"].date(using: "yyyy-MM-dd"),
            let typeShort = json["type_short"].string,
            let typeLong = json["type_long"].string,
            let name = json["name"].string else {
            
            return nil
        }
        
        let details = CafeteriaConstants.parseMensaMenu(name)
        
        self.init(id: json["id"].string,
                  date: date,
                  typeShort: typeShort,
                  typeLong: typeLong,
                  typeNr: json["type_nr"].string,
                  name: name,
                  price: CafeteriaConstants.priceList[typeLong],
                  details: details,
                  mensaId: mensaId)
    }
    
}


struct Price {
    var student: Double
    var employee: Double
    var guest: Double
}

struct MenuDetail {
    var name: String
    var nameWithoutAnnotations: String
    var nameWithEmojiWithoutAnnotations: String
    var annotations: [String]
    var annotationDescriptions: [String]
}
