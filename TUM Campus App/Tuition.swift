//
//  Tuition.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
class Tuition: DataElement {
    
    let frist: NSDate
    let semester: String
    let soll: String
    
    init(frist:NSDate,semester:String,soll:String) {
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