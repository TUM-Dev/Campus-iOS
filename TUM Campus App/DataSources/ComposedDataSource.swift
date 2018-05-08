//
//  ComposedDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 01.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

protocol TUMDataSourceDelegate {
    func didRefreshDataSources()
    func didTimeOutRefreshingDataSource()
}

protocol TUMDataSource: UICollectionViewDataSource {
    var cellType: AnyClass {get set}
    var cellReuseID: String {get}
    var cardReuseID: String {get}
    var isEmpty: Bool {get}
    func refresh(group: DispatchGroup)
}

extension TUMDataSource {
    var cellReuseID: String { return String(describing: self)+"Cell" }
    var cardReuseID: String { return String(describing: self) }
}


class ComposedDataSource: NSObject, UICollectionViewDataSource {
    
    var dataSources: [TUMDataSource] = []
    var manager: TumDataManager
    var delegate: TUMDataSourceDelegate?
    
    init(manager: TumDataManager) {
        self.manager = manager
        self.dataSources = [
            NewsDataSource(manager: manager.newsManager),
            CafeteriaDataSource(manager: manager.cafeteriaManager),
            TUFilmDataSource(manager: manager.tuFilmNewsManager),
            CalendarDataSource(manager: manager.calendarManager),
            TuitionDataSource(manager: manager.tuitionManager),
        ]
        super.init()
    }
    
    func refresh() {
        let group = DispatchGroup()
        dataSources.forEach{$0.refresh(group: group)}
        group.notify(queue: .main) {
            self.delegate?.didRefreshDataSources()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.filter{!$0.isEmpty}.count - 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = dataSources[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath)
        let collectionViewFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: collectionView.frame.size)
        //Think of a better way for more reuse...!
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let childCollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        childCollectionView.dataSource = dataSource
        childCollectionView.register(dataSource.cellType , forCellWithReuseIdentifier: dataSource.cellReuseID)
        childCollectionView.backgroundColor = .red
        cell.addSubview(childCollectionView)

        return cell
    }
}


