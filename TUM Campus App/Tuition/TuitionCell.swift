//
//  TuitionCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 24.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

final class TuitionCell: UITableViewCell {
    @IBOutlet private weak var semesterLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var deadlineLabel: UILabel!

    private static let deadlineDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "dd MMM y"
        return formatter
    }()

    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = "€"
        formatter.numberStyle = .currency
        return formatter
    }()

    func configure(tuition: Tuition) {
        semesterLabel.text = tuition.semester
        if let amount = tuition.amount, let deadline = tuition.deadline {
            amountLabel.text = "\("open Amount".localized) : \(TuitionCell.currencyFormatter.string(from: amount) ?? "n/a".localized)"
            if amount.isEqual(to: 0) {
                amountLabel.textColor = UIColor(red: 13/255, green: 172/255, blue: 23/255, alpha: 1)
            } else {
                amountLabel.textColor = .red
            }
            deadlineLabel.text = "\("Deadline".localized) : \(TuitionCell.deadlineDateFormatter.string(from: deadline))"
        } else {
            amountLabel.text = "n/a".localized
            deadlineLabel.text = "n/a".localized
        }
    }

}
