//
//  CafeteriaCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit
import MapKit

final class CafeteriaCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!

    private static let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()
    
    func configure(cafeteria: Cafeteria, currentLocation: CLLocation?) {
        nameLabel.text = cafeteria.name
        addressLabel.text = cafeteria.location.address
        if let currentLocation = currentLocation {
            let distance = cafeteria.coordinate.location.distance(from: currentLocation)
            distanceLabel.text = CafeteriaCollectionViewCell.distanceFormatter.string(fromDistance: distance)
        } else {
            distanceLabel.text = ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupShadow()
    }

    private func setupShadow() {
        layer.cornerRadius = 8
        layer.backgroundColor = UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.secondarySystemBackground
            default:
                return UIColor.systemBackground
            }
        }.cgColor
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
}
