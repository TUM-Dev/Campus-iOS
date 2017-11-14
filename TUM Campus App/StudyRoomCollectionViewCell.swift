//
//  StudyRoomCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 11.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class StudyRoomCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var roomGroupNameLabel: UILabel!
    @IBOutlet weak var availableRoomsLabel: CircularLabel!
    
    
    func setElement(_ element: DataElement) {
        
        if let element = element as? StudyRoomGroup {
            roomGroupNameLabel.text = element.name
            let availableRooms = element.rooms.reduce(0) { $1.status == .Free ? $0 + 1 : $0 }
            availableRoomsLabel.text = "\(availableRooms)"
            availableRoomsLabel.backgroundColor = availableRooms > 0 ? #colorLiteral(red: 0.3068726243, green: 0.8835613666, blue: 0.4050915909, alpha: 1) : #colorLiteral(red: 1, green: 0.3732958912, blue: 0.357054006, alpha: 1)
        }
    }
    
}
