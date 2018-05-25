//
//  RoomFinderDataSource.swift
//  Campus
//
//  Created by Tim Gymnich on 13.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

class StudyRoomsDataSource: NSObject, TUMDataSource {
    
    var manager: StudyRoomsManager
    var cellType: AnyClass = StudyRoomsCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey = .studyRooms
    var flowLayoutDelegate: UICollectionViewDelegateFlowLayout = UICollectionViewDelegateThreeItemVerticalFlowLayout()
    var data: [StudyRoomGroup] = []
    
    init(manager: StudyRoomsManager) {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! StudyRoomsCollectionViewCell
        let roomGroup = data[indexPath.row]
        
        let availableRoomsCount = roomGroup.rooms.filter{$0.status == StudyRoomStatus.Free }.count
        
        cell.groupNameLabel.text = roomGroup.name
        cell.availableRoomsLabel.text = String(availableRoomsCount)
        
        switch availableRoomsCount {
        case 0: cell.availableRoomsLabel.backgroundColor = .red
        default: cell.availableRoomsLabel.backgroundColor = .green
        }
        
        return cell
    }
    

}
