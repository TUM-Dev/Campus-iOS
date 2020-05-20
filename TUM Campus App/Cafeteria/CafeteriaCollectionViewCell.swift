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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func configure(_ cafeteria: Cafeteria) {
        nameLabel.text = cafeteria.name
        addressLabel.text = cafeteria.location.address
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
        self.layer.cornerRadius = 8
        self.layer.backgroundColor = UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.secondarySystemBackground
            default:
                return UIColor.systemBackground
            }
        }.cgColor
        self.layer.shadowColor = UIColor.systemGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
    }
    
}
