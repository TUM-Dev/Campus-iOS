//
//  NewsDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 01.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit
import Sweeft


class NewsDataSource: NSObject, TUMDataSource {

    var manager: NewsManager
    var cellType: AnyClass = NewsCollectionViewCell.self
    var cellReuseID = "NewsCardCell"
    var cardReuseID = "NewsCard"
    var data: [News] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }

    
    init(manager newsManager: NewsManager) {
        self.manager = newsManager
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
        //TOOD sync fetch
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
    
        cell.backgroundColor = .purple
        
        return cell
    }
    
}
