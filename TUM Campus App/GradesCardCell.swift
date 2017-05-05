//
//  GradesCardCell.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 29.04.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

class GradesCardCell: CardTableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    override func setElement(_ element: DataElement) {
        if let gradeItem = element as? Grade {
            nameLabel.text = gradeItem.name
            gradeLabel.text = gradeItem.result
//            dateLabel.text = gradeItem.date
         
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
