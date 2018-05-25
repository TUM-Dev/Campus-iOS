//
//  CafeteriaCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 03.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class CafeteriaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cafeteriaName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var distanceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
