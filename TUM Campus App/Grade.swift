//
//  Grade.swift
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

final class Grade: DataElement {
    let name: String
    let result: String
    let date: Date
    let semester: String
    let ects: Int
    let examiner: String
    let mode: String
    
    init(name: String, result: String, date: Date, semester: String, ects: Int, examiner: String, mode: String) {
        self.name = name
        self.result = result
        self.date = date
        self.semester = semester
        self.ects = ects
        self.examiner = examiner
        self.mode = mode
    }
    
    func getCellIdentifier() -> String {
        return "grade"
    }
    
    var text: String {
        return name
    }
}

extension Grade: XMLDeserializable {
    
    convenience init?(from xml: XMLIndexer, api: TUMOnlineAPI, maxCache: CacheTime) {
        guard let name = xml["lv_titel"].element?.text,
            let result = xml["uninotenamekurz"].element?.text,
            let date = xml["datum"].element?.text.date(using: "y-M-dd"),
            let semester = xml["lv_semester"].element?.text,
            let ects = xml["lv_credits"].element?.text,
            let examiner = xml["pruefer_nachname"].element?.text,
            let mode = xml["modus"].element?.text else {
                
            return nil
        }
        self.init(name: name, result: result, date: date, semester: semester, ects: Int(ects) ?? 0, examiner: examiner, mode: mode)
    }
    
}
