//
//  CardTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit
import FoldingCell
import MCSwipeTableViewCell

class CardTableViewCell: FoldingCell {
    
    
    func setElement(_ element: DataElement) {
        
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.33, 0.26, 0.26] // timing animation for each view
        return durations[itemIndex]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        foregroundView.layer.cornerRadius = 8
        foregroundView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
}



class TableViewCell: MCSwipeTableViewCell {
    
    func setElement(_ element: DataElement) {
        
    }
    
}

