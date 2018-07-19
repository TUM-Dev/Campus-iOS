//
//  TUMLogoView.swift
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


class TUMLogoView: UIView {
    private static let defaultLogo = #imageLiteral(resourceName: "logo-blue")
    private static let rainbowLogo = #imageLiteral(resourceName: "logo-rainbow")
    
    @IBOutlet weak var imageView: UIImageView!
    
    @objc private func toggleLogo() {
        imageView.image = imageView.image == TUMLogoView.defaultLogo ? TUMLogoView.rainbowLogo : TUMLogoView.defaultLogo
    }
    
    override func awakeFromNib() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleLogo))
        gestureRecognizer.numberOfTapsRequired = 3
        addGestureRecognizer(gestureRecognizer)
    }
}
