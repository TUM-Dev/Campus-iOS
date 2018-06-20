//
//  CalendarDataSource.swift
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


class CalendarDataSource: NSObject, TUMDataSource, TUMInteractiveDataSource {
    
    let parent: CardViewController
    var manager: CalendarManager
    let cellType: AnyClass = CalendarCollectionViewCell.self
    var data: [CalendarRow] = []
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey { return manager.cardKey }
    let dateFormatter = DateFormatter()
    let dateComponentsFormatter = DateComponentsFormatter()
    let preferredHeight: CGFloat = 176.0
    
    lazy var flowLayoutDelegate: UICollectionViewDelegateFlowLayout =
        UICollectionViewDelegateSingleItemFlowLayout(delegate: self)
    
    init(parent: CardViewController, manager: CalendarManager) {
        self.parent = parent
        self.manager = manager
        self.dateFormatter.dateStyle = .full
        self.dateFormatter.timeStyle = .short
        self.dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
        self.dateComponentsFormatter.maximumUnitCount = 2
        self.dateComponentsFormatter.unitsStyle = .full
        super.init()
    }
    
    func refresh(group: DispatchGroup) {
        group.enter()
        manager.fetch().onSuccess(in: .main) { data in
            self.data = data.filter{ $0.start.timeIntervalSinceNow > 0}
            // TODO
            // FOR TESTING PURPOSES
            /*
            self.data = [
                CalendarRow(start: Date(millisecondsSince1970: 1529139600000), end: Date(millisecondsSince1970: 1529139690000), title: "Title 1", description: "Description 1", status: "Status 1", location: "Location 1", url: nil)
            ]
            */
            group.leave()
        }
    }
    
    func onItemSelected(at indexPath: IndexPath) {
        let calendarElement = data[indexPath.row]
        let storyboard = UIStoryboard(name: "Calendar Detail", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? CalendarViewController {
            destination.nextLectureItem = calendarElement
            destination.delegate = parent
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func onShowMore() {
        let storyboard = UIStoryboard(name: "Calendar Detail", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? CalendarViewController {
            destination.delegate = parent
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(data.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! CalendarCollectionViewCell
        let calendarElement = data[indexPath.row]

        cell.titleLabel.text = calendarElement.title
        cell.dateLabel.text = dateFormatter.string(from: calendarElement.start)
        cell.locationLabel.text = calendarElement.location
        
        let timeLeft = Calendar.current.dateComponents([.day, .hour, .minute],
                                                       from: .now, to: calendarElement.start)
        
        if let timeLeftText = dateComponentsFormatter.string(from: timeLeft) {
            cell.timeLeftLabel.text = "in \(timeLeftText)"
            cell.timeLeftLabel.isHidden = false
        } else {
            cell.timeLeftLabel.isHidden = true
        }
        
        return cell
    }
    
}
