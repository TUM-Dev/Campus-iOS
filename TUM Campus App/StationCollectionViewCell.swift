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
    
    var station: DetailedStation?
    
    func setRootElement(_ element: DataElement) {
        self.station?.delegate = nil
        guard let station = element as? DetailedStation else { return }
        self.station = station
        self.station?.delegate = self
        stationName.text = station.station.name
    }
    
}

extension StationCollectionViewCell: DetailedStationDelegate {
    
    func station(_ station: DetailedStation, didUpdate departures: [Departure]) {
        collectionView.reloadData()
    }
    
}
