//
//  CalendarDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 01.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit


class CalendarDataSource: NSObject, TUMDataSource {
    
    var manager: CalendarManager
    var cellType: AnyClass = CalendarCollectionViewCell.self
    var cellReuseID = "CalendarCardCell"
    var cardReuseID = "CalendarCard"
    var data: [CalendarRow] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }

    
    init(manager: CalendarManager) {
        self.manager = manager
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data
            group.leave()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
        
        cell.backgroundColor = .green
        
        return cell
    }
    
}
