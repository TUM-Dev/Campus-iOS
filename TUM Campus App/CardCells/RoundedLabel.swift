//
//  RoundedLabel.swift
//  Campus
//
//  Created by Tim Gymnich on 13.11.17.
//  Copyright © 2017 LS1 TUM. All rights reserved.
//

import UIKit

@IBDesignable class RoundedLabel: UILabel {
    
    @IBInspectable var radius: CGFloat = 3.9
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / radius
    }
}

@IBDesignable class RoundedImageView: UIImageView {
    
    @IBInspectable var radius: CGFloat = 12
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / radius
    }
}

@IBDesignable class CircularLabel: UILabel {
    
    @IBInspectable var radius: CGFloat = 2
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = frame.size.height / radius
    }
}
