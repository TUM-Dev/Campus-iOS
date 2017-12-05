//
//  CafeteriaCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 16.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class CafeteriaCollectionViewCell: UICollectionViewCell, MultipleRootDataElementsPresentable {

    @IBOutlet var collectionView: IndexableCollectionView!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cafeteriaNameLabel: UILabel!
    
    
    func setRootElement(_ element: DataElement) {
        
        guard let cafeteria = element as? Cafeteria else { return }
        
        cafeteriaNameLabel.text = cafeteria.name
        
    }
}
