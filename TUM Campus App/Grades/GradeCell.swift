//
//  GradeCell.swift
//  TUMCampusApp
//
//  Created by Mathis Foxius on 22.11.19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

class GradeCell: UITableViewCell {
    
    var gradeString : String?
    
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.tumBlue
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
        }
    }
    @IBOutlet weak var blockView: UIView! {
        didSet {
            blockView.layer.cornerRadius = blockView.bounds.size.width/2
            blockView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var gradeLabel: UILabel! {
        didSet {
            if let gradeString = gradeString {
                if let doubleGrade = Double(gradeString.replacingOccurrences(of: ",", with: ".")){
                        switch doubleGrade {
                        case 0.0...3.9:
                            blockView.backgroundColor = UIColor.green
                        default:
                            blockView.backgroundColor = UIColor.red
                        }
                    }else{
                        blockView.backgroundColor = UIColor.gray
                    }
                    gradeLabel.text = gradeString
                    gradeLabel.font = UIFont.boldSystemFont(ofSize: 12)
                }
            }
            
    }
}
