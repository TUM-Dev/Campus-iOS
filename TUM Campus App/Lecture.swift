//
//  Lecture.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/10/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit


class Lecture: DataElement {
    
    let id: String
    let lectureID: String
    let module: String
    let name: String
    let semester: String
    let sws: Int
    let chair: String
    let contributors: String
    let type: String
    
    var detailsLoaded = false
    
    var details = [(String,String)]()
    
    init(id: String, lectureID: String, module: String, name: String, semester: String, sws: Int, chair: String, contributors: String, type: String) {
        self.id = id
        self.lectureID = lectureID
        self.module = module
        self.name = name
        self.semester = semester
        self.sws = sws
        self.chair = chair
        self.contributors = contributors
        self.type = type
        details.append(("Semester",semester))
        details.append(("Type",type))
        details.append(("Chair",chair))
        details.append(("Contributors",contributors))
    }
    
    func getCellIdentifier() -> String {
        return "lecture"
    }
    
    func getCloseCellHeight() -> CGFloat {
        return 112
    }
    
    func getOpenCellHeight() -> CGFloat {
        return 412
    }
    
    var text: String {
        return name
    }
    
}
