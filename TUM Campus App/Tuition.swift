//
//  Tuition.swift
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
import SWXMLHash

final class Tuition: DataElement {
    
    let frist: Date
    let semester: String
    let soll: Double
    
    init(frist: Date, semester: String, soll: Double) {
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

    convenience init?(from xml: XMLIndexer, api: TUMOnlineAPI, maxCache: CacheTime) {
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "de_DE")
      
        guard let soll = (xml["soll"].element?.text).flatMap(formatter.number(from:)),
            let frist = xml["frist"].element?.text.date(using: "yyyy-MM-dd"),
            let semester = xml["semester_bezeichnung"].element?.text else {
            
            return nil
        }
        self.init(frist: frist, semester: semester, soll: soll.doubleValue)
    }
    
}

extension Tuition {
    
    var isPaid: Bool {
        return soll <= 0
    }
    
}
