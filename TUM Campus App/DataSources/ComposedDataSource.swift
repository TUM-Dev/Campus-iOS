//
//  ComposedDataSource.swift
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

protocol TUMDataSourceDelegate {
    func didRefreshDataSources()
    func didBeginRefreshingDataSources()
}

protocol TUMDataSource: UICollectionViewDataSource {
    var sectionColor: UIColor {get}
    var cellType: AnyClass {get}
    var cellReuseID: String {get}
    var cardReuseID: String {get}
    var isEmpty: Bool {get}
    var cardKey: CardKey {get}
    var flowLayoutDelegate: UICollectionViewDelegateFlowLayout {get}
    var preferredHeight: CGFloat {get}
    func refresh(group: DispatchGroup)
}

extension TUMDataSource {
    var sectionColor: UIColor { return Constants.tumBlue }
    var cellReuseID: String {
        return cardKey.description.replacingOccurrences(of: " ", with: "")+"Cell"
    }
    var cardReuseID: String {
        return cardKey.description.replacingOccurrences(of: " ", with: "")+"Card"
    }
    var preferredHeight: CGFloat { return 220.0 }
}


class ComposedDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dataSources: [TUMDataSource] = []
    var manager: TumDataManager
    var delegate: TUMDataSourceDelegate?
    var cardKeys: [CardKey] { return PersistentCardOrder.value.cards }
    let margin: CGFloat = 20.0

    
    init(manager: TumDataManager) {
        self.manager = manager
        self.dataSources = [
            NewsDataSource(manager: manager.newsManager),
            NewsSpreadDataSource(manager: manager.newsSpreadManager),
            CafeteriaDataSource(manager: manager.cafeteriaManager),
            TUFilmDataSource(manager: manager.tuFilmNewsManager),
            CalendarDataSource(manager: manager.calendarManager),
            TuitionDataSource(manager: manager.tuitionManager),
            MVGStationDataSource(manager: manager.mvgManager),
            GradesDataSource(manager: manager.gradesManager),
            LecturesDataSource(manager: manager.lecturesManager),
            StudyRoomsDataSource(manager: manager.studyRoomsManager),
        ]
        super.init()
    }
    
    func refresh() {
        delegate?.didBeginRefreshingDataSources()
        let group = DispatchGroup()
        dataSources.forEach{$0.refresh(group: group)}
        group.notify(queue: .main) {
            self.delegate?.didRefreshDataSources()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        TODO
//        dataSources.sorted { (<#TUMDataSource#>, <#TUMDataSource#>) -> Bool in <#code#> }
        return dataSources.filter{!$0.isEmpty && cardKeys.contains($0.cardKey)}.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //TODO Maybe this is not that efficient...
        let dataSource = dataSources.filter{!$0.isEmpty && cardKeys.contains($0.cardKey)}[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dataSource.cardReuseID, for: indexPath) as! DataSourceCollectionViewCell
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        cell.collectionView.register(UINib(nibName: String(describing: dataSource.cellType), bundle: .main), forCellWithReuseIdentifier: dataSource.cellReuseID)
        cell.collectionView.collectionViewLayout = layout
        cell.cardNameLabel.text = dataSource.cardKey.description.uppercased()
        cell.cardNameLabel.textColor = dataSource.sectionColor
        cell.collectionView.backgroundColor = .clear
        cell.collectionView.dataSource = dataSource
        cell.collectionView.delegate = dataSource.flowLayoutDelegate
        cell.collectionView.reloadData()
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dataSource = dataSources.filter{!$0.isEmpty && cardKeys.contains($0.cardKey)}[indexPath.row]
        let height: CGFloat
        let width: CGFloat
        
        if collectionView.traitCollection.userInterfaceIdiom == .phone {
            height = dataSource.preferredHeight
            width = collectionView.frame.size.width
        } else {
            height = 400
            width = floor(collectionView.frame.size.width - 1.0 * margin) / 2
        }
        
        return CGSize(width: width, height: height)
    }
    
}


