//
//  StudyRoomCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class StudyRoomCell: UITableViewCell {
    @IBOutlet private weak var roomNameLabel: UILabel!
    @IBOutlet private weak var roomNumberLabel: UILabel!
    @IBOutlet private weak var roomStatusLabel: UILabel!

    private static let dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    private static let secondDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    func configure(room: StudyRoom) {
        roomNameLabel.text = room.name
        roomNumberLabel.text = room.code
        switch room.status {
        case "frei":
            roomStatusLabel.textColor = .systemGreen
            roomStatusLabel.text = "Free".localized
        case "belegt":
            roomStatusLabel.textColor = .systemRed
            if let occupiedUntilString = room.occupiedUntil, let occupiedUntilDate = StudyRoomCell.dateFomatter.date(from: occupiedUntilString) {
                roomStatusLabel.text = "\("Occupied until".localized) \(StudyRoomCell.secondDateFormatter.string(from: occupiedUntilDate))"
            }
        default:
            roomStatusLabel.textColor = .systemGray
            roomStatusLabel.text = "Unknown".localized
        }
    }
}
