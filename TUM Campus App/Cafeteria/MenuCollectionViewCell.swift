//
//  MenuCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 6.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = 8
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
    }
    
}

