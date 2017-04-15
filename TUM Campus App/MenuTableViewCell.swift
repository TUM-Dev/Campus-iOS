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
            
            //Dish Label
            dishLabel.text = menu.details.nameWithEmojiWithoutAnnotations
            
            //Price Label
            if let menuPrice = menu.price?.student {
                let formatter = NumberFormatter()
                formatter.numberStyle = .currency
                formatter.locale = Locale(identifier: "de_DE")
                priceLabel.text = formatter.string(for: menuPrice)

            } else {
                priceLabel.text = ""
            }
            priceLabel.textColor = .gray

            
            //Annotations Label
            annotationsLabel.text = ""
            
            for description in menu.details.annotationDescriptions {
                if menu.details.annotationDescriptions.last != description {
                     annotationsLabel.text!.append("\(description), ")
                } else {
                     annotationsLabel.text!.append(description)
                }
            }
            annotationsLabel.textColor = .gray

        }
    }
    @IBOutlet weak var annotationsLabel: UILabel!
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

}
