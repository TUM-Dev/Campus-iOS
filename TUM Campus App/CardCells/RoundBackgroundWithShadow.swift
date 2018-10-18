//
//  RoundBackgroundWithShadow.swift
//  Campus
//
//  Created by Tim Gymnich on 23.06.18.
//  Copyright © 2018 LS1 TUM. All rights reserved.
//

import UIKit

protocol Shadow {
    var cornerRadius: CGFloat { get set }
    var shadowRadius: CGFloat { get set }
    var shadowOpacity: Float { get set }
    func setup()
}

extension Shadow where Self: UIView {
    
    func setup() {
        layer.cornerRadius = cornerRadius
        addShadow()
    }
    
    func addShadow() {
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        clipsToBounds = false
    }
    
}

@IBDesignable
class ShadowView: UIView, Shadow {
    
    @IBInspectable var cornerRadius: CGFloat = 14.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 8.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
}

@IBDesignable
class ShadowImageView: UIImageView, Shadow {
    
    @IBInspectable var cornerRadius: CGFloat = 14.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 8.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
}

