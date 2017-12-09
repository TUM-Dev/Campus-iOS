//
//  BordereLabel.swift
//  Campus
//
//  Created by Tim Gymnich on 13.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

@IBDesignable class BorderedLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / 3.9
    }
}

@IBDesignable class CircularLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / 2
    }
}
