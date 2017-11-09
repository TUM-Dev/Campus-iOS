//
//  LectureTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/10/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class LectureTableViewCell: CardTableViewCell {

    func setElement(_ element: DataElement) {
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
