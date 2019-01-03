//
//  RoundedViews.swift
//  TUM Campus App
//
//  Created by Tim Gymnich on 1/3/19.
//  Copyright © 2019 TUM. All rights reserved.
//

import UIKit

@IBDesignable class RoundedLabel: UILabel {
    
    @IBInspectable var radius: CGFloat = 6
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}

@IBDesignable class RoundedButton: UIButton {
    
    @IBInspectable var radius: CGFloat = 6
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
}

@IBDesignable class RoundedImageView: UIImageView {
    
    @IBInspectable var radius: CGFloat = 12
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        layer.cornerRadius = radius
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
