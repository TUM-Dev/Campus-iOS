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
    let cellType: AnyClass = NewsCollectionViewCell.self
    var data: [News] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateSingleItemFlowLayout()
    let dateFormatter = DateFormatter()
    let preferredHeight: CGFloat = 195.0

    
    init(manager newsManager: NewsManager) {
        self.manager = newsManager
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .none
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data.filter { $0.source != News.Source.movies }
            group.leave()
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! NewsCollectionViewCell
        let newsElement = data[indexPath.row]
        
        cell.titleLabel.text = newsElement.title
        cell.detailLabel.text = newsElement.text
        cell.dateLabel.text = dateFormatter.string(from: newsElement.date)
        cell.binding = newsElement.image.bind(to: cell.imageView, default: #imageLiteral(resourceName: "movie"))
        cell.sourceLabel.text = newsElement.source.title
        cell.sourceLabel.textColor = newsElement.source.titleColor
        
        return cell
    }
    
}
