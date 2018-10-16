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

    @IBOutlet private weak var lineLabel: UILabel!
    @IBOutlet private weak var destinationLabel: UILabel!
    @IBOutlet private weak var departureLabel: UILabel!

    private var departure: Departure?
    private var timer: Timer?
    private var timerUntilCountdown: Timer?

    deinit {
        timer?.invalidate()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        departure = nil
        lineLabel.text = ""
        destinationLabel.text = ""
        departureLabel.text = ""
    }

    func configure(with departure: Departure) {
        self.departure = departure

        destinationLabel.text = departure.destination
        lineLabel.backgroundColor = UIColor(hexString: departure.lineBackgroundColor)

        if ["u", "s"].contains(departure.product) {
            lineLabel.text = "\(departure.product.uppercased())\(departure.label)"
        } else {
            lineLabel.text = departure.label
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimeRemaining()
        }

        updateTimeRemaining()
    }

    private func updateTimeRemaining() {
        guard let departure = departure else { return }
        let secondsLeft = departure.departureTime.timeIntervalSinceNow

        departureLabel.text = DateComponentsFormatter.shortTimeFormatter.string(from: secondsLeft) ?? ""
    }
}
