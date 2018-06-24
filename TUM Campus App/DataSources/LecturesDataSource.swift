//
//  LecturesDataSource.swift
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

class LecturesDataSource: NSObject, TUMDataSource, TUMInteractiveDataSource {
    
    let parent: CardViewController
    var manager: PersonalLectureManager
    let cellType: AnyClass = LecturesCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let cardKey: CardKey = .lectures
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateThreeItemVerticalFlowLayout()
    var data: [Lecture] = []
    var preferredHeight: CGFloat = 252.0
    
    init(parent: CardViewController, manager: PersonalLectureManager) {
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
    
    func onShowMore() {
        let storyboard = UIStoryboard(name: "Lecture", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? LecturesTableViewController {
            destination.delegate = parent
            destination.values = data
            parent.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellReuseID, for: indexPath) as! LecturesCollectionViewCell
        let lecture = data[indexPath.row]
        
        cell.lectureNameLabel.text = lecture.name
        cell.semesterLabel.text = lecture.semester
        cell.iconLabel.text = String(lecture.type.first ?? "-")
                
        return cell
    }
    
}
