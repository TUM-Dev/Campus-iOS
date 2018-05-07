//
//  TuitionDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 01.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit


class TuitionDataSource: NSObject, TUMDataSource {
    
    var manager: TuitionStatusManager
    var cellType: AnyClass = TuitionCollectionViewCell.self
    var cellReuseID = "TuitionCardCell"
    var cardReuseID = "TuitionCard"
    var data: [Tuition] = []
    var isEmpty: Bool { return data.isEmpty }

    
    init(manager: TuitionStatusManager) {
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
        
        cell.backgroundColor = .orange
        
        return cell
    }
    
}
