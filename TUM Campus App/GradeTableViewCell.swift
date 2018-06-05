//
//  GradeTableViewCell.swift
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

import UIKit

class GradeTableViewCell: CardTableViewCell {
    
    var grade: Grade? {
        didSet {
            if let grade = grade {
                titleLabel.text = grade.name
                resultLabel.text  = "Result: " + grade.result
                let date = "Date: \(grade.date.string(using: "dd.MM.yyyy"))"
                let semester = "Semester: \(grade.semester)"
                let examiner = "Examiner: \(grade.examiner)"
                let mode = "Mode: \(grade.mode)"
                detailsLabel.text =  date + ", " + semester
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
