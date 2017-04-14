//
//  MenuTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class MenuTableViewCell: CardTableViewCell {

    override func setElement(_ element: DataElement) {
        if let menu = element as? CafeteriaMenu {
            dishLabel.text = menu.name
            if let menuPrice = menu.price?.st {

                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "de_DE")
                priceLabel.text = formatter.string(from: NSNumber(value: menuPrice))
            } else {
                priceLabel.text = ""
            }
            priceLabel.textColor = .gray
        }
    }
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

}
