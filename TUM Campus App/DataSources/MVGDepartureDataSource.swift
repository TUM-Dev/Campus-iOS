//
//  MVGDepartureDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 13.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class MVGDepartureDataSource: NSObject, UICollectionViewDataSource {
    
    let cellType: AnyClass = MVGDepartureCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateListFlowLayout()
    var data: [Departure] = []
    let cellReuseID = "DepartureCardCell"
    let cardReuseID = "DepartureCard"
    let dateComponentsFormatter = DateComponentsFormatter()
    
    init(data: [Departure]) {
        self.data = data
        dateComponentsFormatter.unitsStyle = .short
        dateComponentsFormatter.maximumUnitCount = 1
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! MVGDepartureCollectionViewCell
        let departure = data[indexPath.row]
        
        cell.destinationLabel.text = departure.destination
        cell.lineLabel.backgroundColor = UIColor(hexString: departure.lineBackgroundColor)

        if ["u", "s"].contains(departure.product) {
            cell.lineLabel.text = "\(departure.product.uppercased())\(departure.label)"
        } else {
            cell.lineLabel.text = departure.label
        }
        
        cell.departureLabel.text = dateComponentsFormatter.string(from: departure.departureTime.timeIntervalSinceNow) ?? ""
        
        return cell
    }
    
}

