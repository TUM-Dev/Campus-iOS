//
//  MenuItemCollectionViewCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 3/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class MenuItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configure(_ menu: Menu) {
        nameLabel.text = menu.name ?? ""
        detailsLabel.text = menu.type ?? ""
        let price: [MenuPrice]? = menu.price?.allObjects as? [MenuPrice]
        priceLabel.text = price?.first?.price?.stringValue ?? "n/a"
    }
}
