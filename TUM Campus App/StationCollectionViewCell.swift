//
//  MVVCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 09.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class StationCollectionViewCell: UICollectionViewCell, MultipleRootDataElementsPresentable {
    
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet var collectionView: IndexableCollectionView!
    
    func setRootElement(_ element: DataElement) {
        
        guard let station = element as? Station else { return }
        stationName.text = station.name
    }
    
}
