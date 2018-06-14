//
//  CardTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

@IBDesignable class CardTableViewCell: UITableViewCell {
    
    @IBInspectable var topGradientColor: UIColor = UIColor.white
    @IBInspectable var bottomGradientColor: UIColor = UIColor.black
    
    let gradientLayer = CAGradientLayer()
    
    func configureBackgroundGradient() {
        gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.opacity = 0.05
        self.contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureBackgroundGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.configureBackgroundGradient()
    }
        
    func setElement(_ element: DataElement) {
        fatalError("setElement not implemented")
    }
    
}
