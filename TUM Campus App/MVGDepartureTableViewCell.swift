//
//  MVGDepartureTableViewCell.swift
//  Campus
//
//  Created by Florian Fittschen on 16.10.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class MVGDepartureTableViewCell: UITableViewCell {

    static let Identifier = "MVGDepartureTableViewCell"

    @IBOutlet private weak var departureView: DepartureView!

    func configure(with departure: Departure) {
        departureView.configure(with: departure)
    }
}
