//
//  GradeCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 22.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class GradeCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.textColor = UIColor.tumBlue
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
        }
    }
    @IBOutlet weak var blockView: UIView!{
        didSet{
            
            blockView.layer.cornerRadius = 25.0
            blockView.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var gradeLabel: UILabel!{
        didSet{
            gradeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
}
