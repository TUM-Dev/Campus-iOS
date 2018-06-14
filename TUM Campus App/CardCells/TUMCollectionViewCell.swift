//
//  TUMCollectionViewCell.swift
//  Campus
//
//  This file is part of the TUM Campus App distribution https://github.com/TCA-Team/iOS
//  Copyright (c) 2018 TCA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, version 3.
//
//  This program is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
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

