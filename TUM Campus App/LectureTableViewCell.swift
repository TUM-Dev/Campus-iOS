//
//  LectureTableViewCell.swift
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

class LectureTableViewCell: CardTableViewCell {

    override func setElement(_ element: DataElement) {
        if let lecture = element as? Lecture {
            titleLabel.text = lecture.name
            let text = lecture.type + " - " + lecture.semester
            detailsLabel.text = text + " - " + lecture.sws.description + " SWS"
            contributorsLabel.text = lecture.contributors
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = Constants.tumBlue
        }
    }
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var contributorsLabel: UILabel!

}
