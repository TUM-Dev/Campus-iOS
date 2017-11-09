//
//  RoomResultTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

class RoomResultTableViewCell: CardTableViewCell, SingleDataElementPresentable {

    func setElement(_ element: DataElement) {
        if let room = element as? Room {
            roomNameLabel.text = room.name
            buildingNameLabel.text = room.building
        }
    }

    @IBOutlet weak var roomNameLabel: UILabel! {
        didSet {
            roomNameLabel.textColor = Constants.tumBlue
        }
    }
    @IBOutlet weak var buildingNameLabel: UILabel!
}
