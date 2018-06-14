//
//  MenuTableViewCell.swift
//  TUM Campus App
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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
