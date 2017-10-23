//
//  Tuition.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import SWXMLHash

final class Tuition: DataElement {
    
    let frist: Date
    let semester: String
    let soll: String
    
    init(frist:Date,semester:String,soll:String) {
        self.frist = frist
        self.semester = semester
        self.soll = soll
    }
    
    func getCellIdentifier() -> String {
        return "tuition"
    }
    
    var text: String {
        return semester
    }
    
}

extension Tuition: XMLDeserializable {
    
    convenience init?(from xml: XMLIndexer) {
        guard let soll = xml["soll"].element?.text,
            let frist = xml["frist"].element?.text.date(using: "yyyy-MM-dd"),
            let semester = xml["semester_bezeichnung"].element?.text else {
            
            return nil
        }
        self.init(frist: frist, semester: semester, soll: soll)
    }
    
}
