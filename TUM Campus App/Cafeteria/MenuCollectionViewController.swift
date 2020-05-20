//
//  MenuCollectionViewController.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 6.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class MenuCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var menu: Menu? {
        didSet {
            if let date = menu?.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"
                title = formatter.string(for: date) ?? ""
            }
            categories = menu?.categories.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.name < rhs.name
            }) ?? []
        }
    }
    private var categories: [(name: String, dishes: [Dish])] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].dishes.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? MenuSectionHeader else { return UICollectionReusableView() }
        let category = categories[indexPath.section]

        sectionHeader.titleLabel.text = category.name
        return sectionHeader
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCollectionViewCell
        var dish = categories[indexPath.section].dishes[indexPath.row]
        cell.nameLabel.text = dish.name

        if let price = dish.prices["students"] {
            let formatter = NumberFormatter()
            formatter.currencySymbol = "€"
            formatter.numberStyle = .currency

            var basePriceString: String?
            var unitPriceString: String?

            if let basePrice = price.basePrice, basePrice != 0 {
                basePriceString = formatter.string(for: basePrice)
            }

            if let unitPrice = price.unitPrice, let unit = price.unit, unitPrice != 0 {
                unitPriceString = formatter.string(for: unitPrice)?.appending(" / " + unit)
            }

            let divider: String = !(basePriceString?.isEmpty ?? true) && !(unitPriceString?.isEmpty ?? true) ? " + " : ""

            cell.priceLabel.text = (basePriceString ?? "") + divider + (unitPriceString ?? "")
        }

        cell.ingredientsLabel.text = dish.namedIngredients.joined(separator: ", ")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.9, height: CGFloat(130))
    }

}
