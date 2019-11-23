//
//  CalendarEventCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 23.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class CalendarEventCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.textColor = UIColor.tumBlue
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            dateLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }
}
