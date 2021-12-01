//
//  RoomCell.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 24.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

final class RoomCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var roomCodeLabel: UILabel!
    @IBOutlet private weak var purposeLabel: UILabel!

    func configure(room: Room) {
        nameLabel.text = room.info
        roomCodeLabel.text = room.roomCode
        purposeLabel.text = room.purpose
    }
}
