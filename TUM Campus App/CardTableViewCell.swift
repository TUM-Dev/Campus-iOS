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
    
}

class TableViewCell: MCSwipeTableViewCell {
    
    func setElement(_ element: DataElement) {
        
    }
    
}

