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
            priceLabel.text = ""
        }
    }
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

}
