//
//  PersonalGradeManager.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class PersonalGradeManager: Manager {
    
    static var grades = [DataElement]()
    
    var main: TumDataManager?
    
    required init(mainManager: TumDataManager) {
        main = mainManager
    }
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if !PersonalGradeManager.grades.isEmpty {
            handler(PersonalGradeManager.grades)
        } else {
            let url = getURL()
            Alamofire.request(url).responseString() { (response) in
                if let value = response.result.value {
                    let parsedXML = SWXMLHash.parse(value)
                    let rows = parsedXML["rowset"]["row"].all
                    for row in rows {
                        if let name = row["lv_titel"].element?.text, let result = row["uninotenamekurz"].element?.text, let stringDate = row["datum"].element?.text, let semester = row["lv_semester"].element?.text, let stringEcts = row["lv_credits"].element?.text, let examiner = row["pruefer_nachname"].element?.text, let mode = row["modus"].element?.text {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = ("y-M-dd")
                            let date = dateFormatter.date(from: stringDate)
                            let ects = Int(stringEcts) ?? 0
                            let newGrade = Grade(name: name, result: result, date: date!, semester: semester, ects: ects, examiner: examiner, mode: mode)
                            PersonalGradeManager.grades.append(newGrade)
                        }
                    }
                    handler(PersonalGradeManager.grades)
                }
            }
        }
    }
    
    func getURL() -> String {
        let base = TUMOnlineWebServices.BaseUrl.rawValue + TUMOnlineWebServices.PersonalGrades.rawValue
        if let token = main?.getToken() {
            let url = base + "?" + TUMOnlineWebServices.TokenParameter.rawValue + "=" + token
            return url;
        }
        return ""
    }
    
}
