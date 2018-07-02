//
//  MVGDepartureDataSource.swift
//  Campus
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

class MVGDepartureDataSource: NSObject, UICollectionViewDataSource {
    
    let cellType: AnyClass = MVGDepartureCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = ListFlowLayoutDelegate()
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
        return min(data.count, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! MVGDepartureCollectionViewCell
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

