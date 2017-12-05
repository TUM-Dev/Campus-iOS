//
//  CafeteriaMenuCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 22.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class CafeteriaMenuCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    func setElement(_ element: DataElement) {
        if let menu = element as? CafeteriaMenu {
            nameLabel.text = menu.details.name
            if let price = menu.price?.student {
                priceLabel.text = "\(price)€"
            } else {
                priceLabel.text = ""
            }
        }
    }
    
}
