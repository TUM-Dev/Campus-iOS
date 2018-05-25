//
//  LecturesDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 13.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class LecturesDataSource: NSObject, TUMDataSource {
    
    var manager: PersonalLectureManager
    let cellType: AnyClass = LecturesCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    let cardKey: CardKey = .lectures
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateThreeItemVerticalFlowLayout()
    var data: [Lecture] = []
    var preferredHeight: CGFloat = 240.0

    
    init(manager: PersonalLectureManager) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! LecturesCollectionViewCell
        let lecture = data[indexPath.row]
        
        cell.lectureNameLabel.text = lecture.name
        cell.semesterLabel.text = lecture.semester
        cell.iconLabel.text = String(lecture.type.first ?? "-")
                
        return cell
    }
    
}
