//
//  TUFilmDataSource.swift
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
import Kingfisher

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
        cell.moviePosterImageView.clipsToBounds = true
        
        if let imageUrl = movie.imageUrl {
            cell.moviePosterImageView.kf.setImage(with: URL(string: imageUrl), placeholder: #imageLiteral(resourceName: "movie"))
        }

        return cell
    }
    
}

