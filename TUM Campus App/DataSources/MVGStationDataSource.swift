//
//  MVGStationDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 13.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
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
    var preferredHeight: CGFloat = 230.0
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! MVGStationCollectionViewCell
        let station = data[indexPath.row]
        let departureDataSource = departureDataSources[indexPath.row]
//        TODO distance
        cell.collectionView.register(UINib(nibName: String(describing: departureDataSource.cellType), bundle: .main), forCellWithReuseIdentifier: departureDataSource.cellReuseID)
        cell.stationNameLabel.text = station.station.name
        cell.collectionView.dataSource = departureDataSource
        cell.collectionView.delegate = departureDataSource.flowLayoutDelegate
        
        return cell
    }
    
}
