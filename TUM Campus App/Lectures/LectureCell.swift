//
//  LectureTableViewCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 22.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class LectureCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var speakerLabel: UILabel!
    @IBOutlet private weak var eventType: UILabel!

    func configure(lecture: Lecture) {
        titleLabel.text = lecture.title
        speakerLabel.text = lecture.speaker
        eventType.text = lecture.eventType
    }
}
