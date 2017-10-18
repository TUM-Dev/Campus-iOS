//
//  CardTableViewCell.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import UIKit

@IBDesignable class CardTableViewCell: UITableViewCell {
	
	@IBInspectable var color1: UIColor = UIColor.white
	@IBInspectable var color2: UIColor = UIColor.black
    
    let gradientLayer = CAGradientLayer()
    
    func configureBackgroundGradient() {
        print(self.reuseIdentifier)
        print(self.frame)
        self.contentView.clipsToBounds = true
        self.clipsToBounds = true
//        if let gradientLayer = self.layer.sublayers?[0] as? CAGradientLayer {
        self.gradientLayer.removeFromSuperlayer()
            gradientLayer.colors = [color1.cgColor, color2.cgColor]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = bounds
            gradientLayer.opacity = 0.05
//        } else {
//            gradientLayer.colors = [color1.cgColor, color2.cgColor]
//            gradientLayer.locations = [0.0, 1.0]
//            gradientLayer.frame = frame
//            gradientLayer.opacity = 0.05
            self.contentView.layer.insertSublayer(gradientLayer, at: 0)
//        }
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
