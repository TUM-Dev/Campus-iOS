//
//  MVGStationDataSource.swift
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

class MVGStationDataSource: NSObject, TUMDataSource {
    
    var manager: MVGManager
    let cellType: AnyClass = MVGStationCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let cardKey: CardKey = .mvg
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateSingleItemFlowLayout()
    var data: [DetailedStation] = []
    var departureDataSources: [MVGDepartureDataSource] = []
    var preferredHeight: CGFloat = 290.0
    
    init(manager: MVGManager) {
        self.manager = manager
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data
            self.departureDataSources = data.map { MVGDepartureDataSource(data: $0.departures) }
            group.leave()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! MVGStationCollectionViewCell
        let station = data[indexPath.row]
        let departureDataSource = departureDataSources[indexPath.row]
//        TODO distance
        
        let nib = UINib(nibName: String(describing: departureDataSource.cellType), bundle: .main)
        cell.collectionView.register(nib, forCellWithReuseIdentifier: departureDataSource.cellReuseID)
        
        cell.stationNameLabel.text = station.station.name
        cell.collectionView.dataSource = departureDataSource
        cell.collectionView.delegate = departureDataSource.flowLayoutDelegate
        
        return cell
    }
    
}
