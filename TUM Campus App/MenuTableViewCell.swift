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
            print(menu.details.annotationDescriptions)
            
            annotationsLabel.text = ""
//            menu.details.annotationDescriptions.forEach({annotationsLabel.text!.append("\($0) ")})
            
            for description in menu.details.annotationDescriptions {
                if menu.details.annotationDescriptions.last != description {
                     annotationsLabel.text!.append("\(description), ")
                } else {
                     annotationsLabel.text!.append(description)
                }
               
            }
            
            
            priceLabel.textColor = .gray
            annotationsLabel.textColor = .gray
        }
    }
    @IBOutlet weak var annotationsLabel: UILabel!
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

}
