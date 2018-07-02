//
//  NewsSpreadDataSource.swift
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
import Sweeft

class NewsSpreadDataSource: NSObject, TUMDataSource, TUMInteractiveDataSource {
    
    let parent: CardViewController
    var manager: NewsSpreadManager
    var cellType: AnyClass = NewsSpreadCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey = .newsspread
    var data: [News] = []
    let preferredHeight: CGFloat = 180.0
    
    lazy var flowLayoutDelegate: ColumnsFlowLayoutDelegate =
        VariableColumnsFlowLayoutDelegate(aspectRatio: CGFloat(2/1), delegate: self)
    
    init(parent: CardViewController, manager: NewsSpreadManager) {
        self.parent = parent
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
    
    func onItemSelected(at indexPath: IndexPath) {
        let item = data[indexPath.row]
        item.open(sender: parent)
    }
    
    func onShowMore() {
        let storyboard = UIStoryboard(name: "News", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? NewsTableViewController {
            destination.delegate = parent
            destination.values = data
            destination.navigationTitle = manager.source.title
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(data.count, 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! NewsSpreadCollectionViewCell
        
        let newsElement = data[indexPath.row]
        
        if let imageUrl = newsElement.imageUrl {
            cell.imageView.kf.setImage(with: URL(string: imageUrl),
                                       placeholder: #imageLiteral(resourceName: "movie"), options: [.transition(.fade(0.2))])
        } else {
            cell.imageView.image = nil
        }

        return cell
    }
    
}
