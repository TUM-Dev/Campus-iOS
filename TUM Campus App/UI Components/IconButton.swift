//
//  IconButton.swift
//  TUMCampusApp
//
//  Created by Tim Gymnich on 25.5.20.
//  Copyright © 2020 TUM. All rights reserved.
//

import UIKit

@IBDesignable
final class IconButton: UIButton {
    @IBInspectable var pointSize: CGFloat = 30.0

    override func layoutSubviews() {
        super.layoutSubviews()
        let config = UIImage.SymbolConfiguration(pointSize: pointSize)
        setPreferredSymbolConfiguration(config, forImageIn: .normal)
    }
}
