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
    let cellType: AnyClass = TuitionCollectionViewCell.self
    var data: [Tuition] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateSingleItemFlowLayout()
    let dateFormatter = DateFormatter()
    let numberFormatter = NumberFormatter()
    let preferredHeight: CGFloat = 120.0

    
    init(manager: TuitionStatusManager) {
        self.manager = manager
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .none
        self.numberFormatter.numberStyle = .currency
        self.numberFormatter.currencySymbol = "€"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! TuitionCollectionViewCell
        let tuition = data[indexPath.row]
        
        cell.balanceLabel.text = numberFormatter.string(from: NSNumber(value: tuition.soll))
        cell.deadlineLabel.text = dateFormatter.string(from: tuition.frist)
        
        return cell
    }
    
}
