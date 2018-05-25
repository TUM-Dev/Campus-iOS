//
//  TUFilmDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 01.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit


class TUFilmDataSource: NSObject, TUMDataSource {
    
    var manager: TUFilmNewsManager
    let cellType: AnyClass = TUFilmCollectionViewCell.self
    var data: [News] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateThreeItemHorizontalFlowLayout()

    
    init(manager: TUFilmNewsManager) {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! TUFilmCollectionViewCell
        let movie = data[indexPath.row]
        
        cell.titleLabel.text = String(movie.text.split(separator: ":").last ?? "")
        cell.binding = movie.image.bind(to: cell.moviePosterImageView, default: #imageLiteral(resourceName: "movie"))
        cell.moviePosterImageView.clipsToBounds = true

        return cell
    }
    
}

