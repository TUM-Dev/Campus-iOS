//
//  CalendarEventCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class CalendarEventCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationIconImageView: UIImageView!
    @IBOutlet private weak var locationLabel: UILabel!

    private static let startDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMM y || HH:mm"
        return formatter
    }()

    private static let endDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    func configure(event: CalendarEvent) {
        titleLabel.text = event.title
        if let startDate = event.startDate, let endDate = event.endDate {
            dateLabel.text = "\(CalendarEventCell.startDateFormatter.string(from: startDate)) - \(CalendarEventCell.endDateFormatter.string(from: endDate))"
        } else {
            dateLabel.text = "n/a".localized
        }
        if let location = event.location {
            locationLabel.text = location
            locationIconImageView.isHidden = false
            locationLabel.isHidden = false
        } else {
            locationIconImageView.isHidden = true
            locationLabel.isHidden = true
        }
    }
}
