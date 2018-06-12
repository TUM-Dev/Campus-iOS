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
    
    var gradeColor: UIColor? {
        switch Double(result.replacingOccurrences(of: ",", with: "."))  {
        case .some(let grade):
            switch grade {
            case 1.0: return GradeColor.grade_1_0.colorValue
            case 1.3: return GradeColor.grade_1_3.colorValue
            case 1.4: return GradeColor.grade_1_4.colorValue
            case 1.7: return GradeColor.grade_1_7.colorValue
            case 2.0: return GradeColor.grade_2_0.colorValue
            case 2.3: return GradeColor.grade_2_3.colorValue
            case 2.4: return GradeColor.grade_2_4.colorValue
            case 2.7: return GradeColor.grade_2_7.colorValue
            case 3.0: return GradeColor.grade_3_0.colorValue
            case 3.3: return GradeColor.grade_3_3.colorValue
            case 3.4: return GradeColor.grade_3_4.colorValue
            case 3.7: return GradeColor.grade_3_7.colorValue
            case 4.0: return GradeColor.grade_4_0.colorValue
            case 4.3: return GradeColor.grade_4_3.colorValue
            case 4.4: return GradeColor.grade_4_4.colorValue
            case 4.7: return GradeColor.grade_4_7.colorValue
            case 5.0: return GradeColor.grade_5_0.colorValue
            default: return GradeColor.unknown.colorValue
            }
        case .none: return GradeColor.unknown.colorValue
        }
    }
    
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
