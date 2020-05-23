//
//  MenuCollectionViewCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 6.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!

    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencySymbol = "€"
        formatter.numberStyle = .currency
        return formatter
    }()


    func configure(dish: Dish) {
        nameLabel.text = dish.name

        if let price = dish.prices["students"] {
            var basePriceString: String?
            var unitPriceString: String?

            if let basePrice = price.basePrice, basePrice != 0 {
                basePriceString = MenuCollectionViewCell.priceFormatter.string(for: basePrice)
            }

            if let unitPrice = price.unitPrice, let unit = price.unit, unitPrice != 0 {
                unitPriceString = MenuCollectionViewCell.priceFormatter.string(for: unitPrice)?.appending(" / " + unit)
            }

            let divider: String = !(basePriceString?.isEmpty ?? true) && !(unitPriceString?.isEmpty ?? true) ? " + " : ""

            priceLabel.text = (basePriceString ?? "") + divider + (unitPriceString ?? "")
        } else {
            priceLabel.text = "n/a"
        }

        ingredientsLabel.text = dish.namedIngredients.joined(separator: ", ")
    }

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

