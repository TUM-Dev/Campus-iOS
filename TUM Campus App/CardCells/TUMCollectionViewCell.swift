//
//  TUMCollectionViewCell.swift
//  Campus
//
//  Created by Tim Gymnich on 09.05.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

@IBDesignable class TUMCollectionViewCell: UICollectionViewCell {
    
    @IBInspectable var topGradientColor: UIColor = UIColor.white
    @IBInspectable var bottomGradientColor: UIColor = UIColor.black
    
    let gradientLayer = CAGradientLayer()
    var gradientView: UIView!
    
    func configureBackgroundGradient() {

        gradientView = UIView(frame: frame)
        gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        gradientLayer.opacity = 0.05
        
//        contentView.backgroundColor = .red
//        gradientView.layer.addSublayer(gradientLayer)
//        contentView.addSubview(gradientView)
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
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

