//
//  StudyRoomGroupedTableViewCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class StudyRoomGroupedTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!

    func configure(group:  StudyRoomGroup) {
        titleLabel.text = group.name
        numberLabel.text = "\(group.rooms?.count ?? 0)"
    }
}
