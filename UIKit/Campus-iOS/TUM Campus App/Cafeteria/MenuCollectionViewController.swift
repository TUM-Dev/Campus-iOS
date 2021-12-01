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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int { categories.count }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { categories[section].dishes.count }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MenuSectionHeader.reuseIdentifier, for: indexPath) as? MenuSectionHeader else { return UICollectionReusableView() }
        let category = categories[indexPath.section]

        sectionHeader.titleLabel.text = category.name
        return sectionHeader
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.reuseIdentifier, for: indexPath) as! MenuCollectionViewCell
        let dish = categories[indexPath.section].dishes[indexPath.row]

        cell.configure(dish: dish)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.9, height: CGFloat(130))
    }

}
