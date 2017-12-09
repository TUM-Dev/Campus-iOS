//
//  BorderedButton.swift
//  Campus
//
//  Created by Tim Gymnich on 20.10.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

@IBDesignable class BorderedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / 3.9
    }
}
