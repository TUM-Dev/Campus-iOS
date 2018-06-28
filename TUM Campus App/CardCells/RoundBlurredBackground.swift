//
//  RoundBlurredButton.swift
//  Campus
//
//  Created by Till on 15.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

@IBDesignable
class RoundBlurredBackground: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 12 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    private func sharedInit() {
        refreshCorners(value: cornerRadius)
        clipsToBounds = true
        addBlur()
    }
    
    private func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    private func addBlur() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blur.frame = self.bounds
        blur.layer.cornerRadius = cornerRadius
        blur.clipsToBounds = true
        blur.backgroundColor = UIColor.lightGray
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
    }
    
}
