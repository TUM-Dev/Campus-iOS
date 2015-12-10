//
//  Lecture.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/10/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
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
    }
    
    func getCellIdentifier() -> String {
        return "lecture"
    }
    
    var text: String {
        return name
    }
    
}