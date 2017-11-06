//
//  EmptyCardCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/17/16.
//  Copyright © 2016 LS1 TUM. All rights reserved.
//

import UIKit

class EmptyCardCell: CardTableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func setElement(_ element: DataElement) {
        assert(element is EmptyCard)
    }
    
}
