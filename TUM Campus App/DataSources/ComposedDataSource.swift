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
    func didBeginRefreshingDataSources()
}

protocol TUMDataSource: UICollectionViewDataSource {
    var cellType: AnyClass {get set}
    var cellReuseID: String {get}
    var cardReuseID: String {get}
    var isEmpty: Bool {get}
    var cardKey: CardKey {get}
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
    var cardKeys: [CardKey] { return PersistentCardOrder.value.cards }
    
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
        delegate?.didBeginRefreshingDataSources()
        let group = DispatchGroup()
        dataSources.forEach{$0.refresh(group: group)}
        group.notify(queue: .main) {
            self.delegate?.didRefreshDataSources()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.filter{!$0.isEmpty && cardKeys.contains($0.cardKey)}.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO Maybe this is not that efficient...
        let dataSource = dataSources.filter{!$0.isEmpty && cardKeys.contains($0.cardKey)}[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath)
        let collectionViewFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: collectionView.frame.size)
        //TODO Think of a better way for more reuse...!
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let childCollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        childCollectionView.dataSource = dataSource
        childCollectionView.register(dataSource.cellType , forCellWithReuseIdentifier: dataSource.cellReuseID)
        childCollectionView.backgroundColor = .red
        childCollectionView.isPagingEnabled = true
        //TODO appending a new subview every time
        cell.addSubview(childCollectionView)

        return cell
    }

}


