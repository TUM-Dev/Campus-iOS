//
//  GradeTableViewCell.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class GradeTableViewCell: TableViewCell {
    
    var grade: Grade? {
        didSet {
            if let grade = grade {
                titleLabel.text = grade.name
                resultLabel.text  = "Restult: " + grade.result
                let date = "Date: \(grade.date.string(using: "dd.MM.yyyy"))"
                let semester = "Semester: \(grade.semester)"
                let ects = "ECTS: \(grade.ects)"
                let examiner = "Examiner: \(grade.examiner)"
                let mode = "Mode: \(grade.mode)"
                detailsLabel.text =  date + ", " + semester +  ", " + ects
                secondDetailsLabel.text =  examiner + ", " + mode
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = Constants.tumBlue
        }
    }
    @IBOutlet weak var resultLabel: UILabel! {
        didSet {
            resultLabel.textColor = Constants.tumBlue
        }
    }
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var secondDetailsLabel: UILabel!

}
