//
//  CafeteriaCardTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class CafeteriaCardTableViewCell: CardTableViewCell {

    override func setElement(element: DataElement) {
        if let cafeteria = element as? Cafeteria {
            cafeteriaLabel.text = cafeteria.name
            let items = cafeteria.getMenusForDate(NSDate()).filter() { (item) in
                return item.id != 0
            }
            var string = ""
            for item in items {
                string += "\u{2022} " + item.name + "\n"
            }
            itemsLabel.text = string
        }
    }

    @IBOutlet weak var cafeteriaLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            backgroundColor = UIColor.clearColor()
            cardView.layer.shadowOpacity = 0.4
            cardView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        }
    }
}
