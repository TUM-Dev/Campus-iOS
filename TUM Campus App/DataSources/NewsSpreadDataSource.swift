//
//  NewsSpreadDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 17.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft


class NewsSpreadDataSource: NSObject, TUMDataSource {
    
    var manager: NewsSpreadManager
    var cellType: AnyClass = NewsSpreadCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey = .newsspread
    var data: [News] = []
    let preferredHeight: CGFloat = 180.0
    
    var flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateLandscapeItemFlowLayout()
    
    
    init(manager: NewsSpreadManager) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! NewsSpreadCollectionViewCell
        let newsElement = data[indexPath.row]
        
        cell.binding = newsElement.image.bind(to: cell.imageView, default: #imageLiteral(resourceName: "movie"))

        return cell
    }
    
    
}
