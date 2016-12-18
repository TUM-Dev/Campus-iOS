//
//  StudyRoomTableViewCell.swift
//  TUM Campus App
//
//  Created by Max Muth on 18.12.16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class StudyRoomsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nextEvent: UILabel!
    @IBOutlet weak var buildingName: UILabel!
    
    var studyRoomItem: StudyRoom? {
        didSet {
            if let studyRoomItem = studyRoomItem {
                code.text = studyRoomItem.code
                name.text = studyRoomItem.name
                nextEvent.text = studyRoomItem.nextEvent
                buildingName.text = studyRoomItem.buildingName
                
                let background = studyRoomItem.status == StudyRoomStatus.Free ? Constants.StudyRoomFree : Constants.StudyRoomOccupied
                self.backgroundColor = background
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
