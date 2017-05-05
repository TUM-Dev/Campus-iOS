//
//  EmptyCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class EmptyCardCell: CardTableViewCell {
    
    
    override func setElement(_ element: DataElement) {
        assert(element is EmptyCard)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
