//
//  GradeTableViewCell.swift
//  TUM Campus App
//
//  Created by Florian Gareis on 04.02.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class GradeTableViewCell: CardTableViewCell {
    
    var grade: Grade? {
        didSet {
            if let grade = grade {
                titleLabel.text = grade.name
                resultLabel.text  = "Restult: " + grade.result
                let day = String (Calendar.current.component(.day, from: grade.date))
                let month = String(Calendar.current.component(.month, from: grade.date))
                let year = String(Calendar.current.component(.year, from: grade.date))
                let date = "Date: " + day + "." + month + "." + year
                let semester = "Semester: " + grade.semester
                let ects = "ECTS: " + String(grade.ects)
                let examiner = grade.examiner
                let mode = grade.mode
                detailsLabel.text =  date + ", " + semester +  ", " + ects
                secondDetailsLabel.text = "Examiner: " + examiner + ", Mode: " + mode
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
