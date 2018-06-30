//
//  NewsDataSource.swift
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

class NewsDataSource: NSObject, TUMDataSource, TUMInteractiveDataSource {
    
    let parent: CardViewController
    var manager: NewsManager
    let cellType: AnyClass = NewsCollectionViewCell.self
    var data: [News] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }
    
    lazy var flowLayoutDelegate: ColumnsFlowLayout =
        FixedColumnsFlowLayout(delegate: self)
    
    let dateFormatter = DateFormatter()
    let preferredHeight: CGFloat = 186.0
    
    init(parent: CardViewController, manager newsManager: NewsManager) {
        self.parent = parent
        self.manager = newsManager
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .none
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data
                .filter { $0.source != News.Source.movies && $0.source != News.Source.newsSpread }
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
            destination.navigationTitle = "News"
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return min(data.count, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! NewsCollectionViewCell
        let newsElement = data[indexPath.row]
        
        cell.titleLabel.text = newsElement.title
        cell.dateLabel.text = dateFormatter.string(from: newsElement.date)
        cell.sourceLabel.text = newsElement.source.title
        cell.sourceLabel.textColor = newsElement.source.titleColor
        
        if let imageUrl = newsElement.imageUrl {
            cell.imageView.kf.setImage(with: URL(string: imageUrl),
                                       options: [.transition(.fade(0.2))])
        } else {
            cell.imageView.image = nil
        }
        
        return cell
    }
    
}
