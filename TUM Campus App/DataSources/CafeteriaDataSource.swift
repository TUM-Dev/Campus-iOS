//
//  CafeteriaDataSource.swift
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
import MapKit


class CafeteriaDataSource: NSObject, TUMDataSource, TUMInteractiveDataSource {
    
    let parent: CardViewController
    var manager: CafeteriaManager
    let cellType: AnyClass = CafeteriaCollectionViewCell.self
    var data: [Cafeteria] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }
    let preferredHeight: CGFloat = 366.0
    var menuDataSources: [MenuDataSource] = []
    let distanceFormatter = MKDistanceFormatter()
    
    lazy var flowLayoutDelegate: ColumnsFlowLayoutDelegate =
        FixedColumnsFlowLayoutDelegate(delegate: self)
    
    init(parent: CardViewController, manager: CafeteriaManager) {
        self.parent = parent
        self.manager = manager
        self.distanceFormatter.unitStyle = .abbreviated
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data.filter {$0.hasMenuToday}//$0.distance(self.manager.location) < 2500}
            self.menuDataSources = data.map { MenuDataSource(data: $0.getMenusForDate(.now)) }
            group.leave()
        }
    }
    
    func onShowMore() {
        let storyboard = UIStoryboard(name: "Cafeteria", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? CafeteriaViewController {
            destination.delegate = parent
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(data.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! CafeteriaCollectionViewCell
        let cafeteria = data[indexPath.row]
        let menuDataSource = menuDataSources[indexPath.row]
        
        let menu = cafeteria.getMenusForDate(.now)
        //TODO: display menu for tomorrow if today is over
        let menuTomorrow = cafeteria.getMenusForDate(.now + .aboutOneDay)
        
        // Display a placeholder label if no cafeteria data is available
        let isMenuEmpty = menuDataSource.data.isEmpty
        cell.placeholderLabel.isHidden = !isMenuEmpty
        cell.collectionView.isHidden = isMenuEmpty
        
        cell.collectionView.register(UINib(nibName: String(describing: menuDataSource.cellType), bundle: .main), forCellWithReuseIdentifier: menuDataSource.cellReuseID)
        cell.cafeteriaName.text = cafeteria.name
        cell.distanceLabel.text = distanceFormatter.string(fromDistance: cafeteria.distance(manager.location))
        cell.collectionView.dataSource = menuDataSource
        cell.collectionView.delegate = menuDataSource.flowLayoutDelegate
        
        return cell
    }
    
    
}
