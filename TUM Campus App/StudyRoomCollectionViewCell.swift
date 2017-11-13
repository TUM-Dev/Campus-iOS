//
//  StudyRoomCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 11.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit


class StudyRoomCollectionViewCell: UICollectionViewCell, SingleDataElementPresentable {
    
    @IBOutlet weak var label1: UILabel!
    
    
    func setElement(_ element: DataElement) {
        
        if let element = element as? StudyRoomGroup {
            label1.text = element.name
            let availabelRooms = element.rooms.reduce(0) { $1.status == .Free ? $0 + 1 : $0 }
            label1.text! += " \(availabelRooms)"
        }
    }
    
}
