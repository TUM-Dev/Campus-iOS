//
//  Grade.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
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
    
    convenience init?(from xml: XMLIndexer) {
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
