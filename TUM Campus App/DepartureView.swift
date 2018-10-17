//
//  DepartureView.swift
//  Campus
//
//  Created by Florian Fittschen on 16.10.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class DepartureView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var lineLabel: UILabel!
    @IBOutlet private weak var destinationLabel: UILabel!
    @IBOutlet private weak var departureLabel: UILabel! {
        didSet {
            // Use monospaced font to avoid a jumping destinationLabel on every tick of the countdown
            departureLabel.font = UIFont.monospacedDigitSystemFont(ofSize: departureLabel!.font!.pointSize,
                                                                   weight: UIFont.Weight.regular)
        }
    }

    private var departure: Departure?
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    deinit {
        timer?.invalidate()
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

    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: DepartureView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func updateTimeRemaining() {
        guard let departure = departure else { return }
        let secondsLeft = departure.departureTime.timeIntervalSinceNow

        departureLabel.text = DateComponentsFormatter.shortTimeFormatter.string(from: secondsLeft) ?? ""
    }
}
