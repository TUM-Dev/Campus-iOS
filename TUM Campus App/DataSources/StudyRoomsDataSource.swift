//
//  RoomFinderDataSource.swift
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

class StudyRoomsDataSource: NSObject, TUMDataSource, TUMInteractiveDataSource {
    
    let parent: CardViewController
    var manager: StudyRoomsManager
    var cellType: AnyClass = StudyRoomsCollectionViewCell.self
    var isEmpty: Bool { return data.isEmpty }
    var cardKey: CardKey = .studyRooms
    var data: [StudyRoomGroup] = []
    
    lazy var flowLayoutDelegate: ColumnsFlowLayout =
        FixedColumnsVerticalItemsFlowLayout(delegate: self)
    
    init(parent: CardViewController, manager: StudyRoomsManager) {
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
        let studyRoomGroup = data[indexPath.row]
        openStudyRooms(with: studyRoomGroup)
    }
    
    func onShowMore() {
        openStudyRooms()
    }
    
    private func openStudyRooms(with currentGroup: StudyRoomGroup? = nil) {
        let storyboard = UIStoryboard(name: "StudyRooms", bundle: nil)
        if let destination = storyboard.instantiateInitialViewController() as? StudyRoomsTableViewController {
            destination.delegate = parent
            destination.roomGroups = data
            destination.currentGroup = currentGroup
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
            withReuseIdentifier: cellReuseID, for: indexPath) as! StudyRoomsCollectionViewCell
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
