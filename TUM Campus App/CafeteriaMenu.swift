//
//  CafeteriaMenu.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/1/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
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
