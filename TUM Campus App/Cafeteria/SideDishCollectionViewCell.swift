//
//  SideDishCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class SideDishCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configure(_ sideDish: SideDish) {
        self.nameLabel.text = sideDish.name ?? ""
        self.detailsLabel.text = sideDish.type ?? ""
        self.priceLabel.text = "n/a"
    }
    
}

